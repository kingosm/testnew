import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ImageUpload } from "@/components/ui/image-upload";
import { Plus, Pencil, Trash2, Eye, EyeOff, Loader2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { cn } from "@/lib/utils";

interface Restaurant {
    id: string;
    name: string;
}

interface MenuItem {
    id: string;
    restaurant_id: string;
    name: string;
    description: string | null;
    price: number | null;
    image_url: string | null;
    category: string | null;
    is_visible: boolean;
    created_at: string;
}

interface MenuManagementDialogProps {
    restaurant: Restaurant | null;
    isOpen: boolean;
    onClose: () => void;
}

export function MenuManagementDialog({ restaurant, isOpen, onClose }: MenuManagementDialogProps) {
    const { toast } = useToast();
    const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
    const [isLoading, setIsLoading] = useState(false);

    // Form State
    const [isEditing, setIsEditing] = useState(false);
    const [currentitem, setCurrentItem] = useState<Partial<MenuItem>>({
        is_visible: true
    });
    const [isFormOpen, setIsFormOpen] = useState(false);

    useEffect(() => {
        if (isOpen && restaurant) {
            fetchMenuItems();
            setIsFormOpen(false);
            setCurrentItem({ is_visible: true });
        }
    }, [isOpen, restaurant]);

    const fetchMenuItems = async () => {
        if (!restaurant) return;
        setIsLoading(true);
        const { data, error } = await supabase
            .from("menu_items")
            .select("*")
            .eq("restaurant_id", restaurant.id)
            .order("created_at", { ascending: false });

        if (error) {
            console.error("Error fetching menu items:", error);
            toast({ title: "Error", description: "Failed to load menu items", variant: "destructive" });
        } else {
            setMenuItems(data as unknown as MenuItem[]);
        }
        setIsLoading(false);
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!restaurant) return;

        try {
            if (isEditing && currentitem.id) {
                const { error } = await supabase
                    .from("menu_items")
                    .update({
                        name: currentitem.name,
                        description: currentitem.description,
                        price: currentitem.price,
                        image_url: currentitem.image_url,
                        category: currentitem.category,
                        is_visible: currentitem.is_visible
                    })
                    .eq("id", currentitem.id);

                if (error) throw error;
                toast({ title: "Success", description: "Menu item updated" });
            } else {
                if (!currentitem.name) throw new Error("Name is required");

                const newItem = {
                    restaurant_id: restaurant.id,
                    name: currentitem.name,
                    description: currentitem.description,
                    price: currentitem.price,
                    image_url: currentitem.image_url,
                    category: currentitem.category,
                    is_visible: currentitem.is_visible ?? true
                };

                const { error } = await supabase
                    .from("menu_items")
                    .insert([newItem]);

                if (error) throw error;
                toast({ title: "Success", description: "Menu item created" });
            }

            setIsFormOpen(false);
            setCurrentItem({ is_visible: true });
            fetchMenuItems();
        } catch (error: any) {
            toast({ title: "Error", description: error.message, variant: "destructive" });
        }
    };

    const handleDelete = async (id: string) => {
        if (!confirm("Are you sure you want to delete this item?")) return;

        try {
            const { error } = await supabase
                .from("menu_items")
                .delete()
                .eq("id", id);

            if (error) throw error;
            toast({ title: "Success", description: "Item deleted" });
            fetchMenuItems();
        } catch (error: any) {
            toast({ title: "Error", description: error.message, variant: "destructive" });
        }
    };

    const toggleVisibility = async (item: MenuItem) => {
        try {
            const { error } = await supabase
                .from("menu_items")
                .update({ is_visible: !item.is_visible } as any)
                .eq("id", item.id);

            if (error) throw error;
            fetchMenuItems(); // Refresh to show correct state
        } catch (error: any) {
            toast({ title: "Error", description: error.message, variant: "destructive" });
        }
    };

    const startEdit = (item: MenuItem) => {
        setCurrentItem(item);
        setIsEditing(true);
        setIsFormOpen(true);
    };

    const startCreate = () => {
        setCurrentItem({ is_visible: true });
        setIsEditing(false);
        setIsFormOpen(true);
    };

    if (!restaurant) return null;

    return (
        <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
            <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>Menu for {restaurant.name}</DialogTitle>
                </DialogHeader>

                {isFormOpen ? (
                    <form onSubmit={handleSubmit} className="space-y-4 border p-4 rounded-md">
                        <div className="flex justify-between items-center mb-4">
                            <h3 className="text-lg font-semibold">{isEditing ? "Edit Item" : "Add New Item"}</h3>
                            <Button type="button" variant="ghost" onClick={() => setIsFormOpen(false)}>Cancel</Button>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div className="space-y-2">
                                <Label htmlFor="item-name">Name *</Label>
                                <Input
                                    id="item-name"
                                    value={currentitem.name || ""}
                                    onChange={(e) => setCurrentItem({ ...currentitem, name: e.target.value })}
                                    required
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="item-price">Price (IQD)</Label>
                                <Input
                                    id="item-price"
                                    type="number"
                                    step="0.01"
                                    value={currentitem.price || ""}
                                    onChange={(e) => setCurrentItem({ ...currentitem, price: parseFloat(e.target.value) })}
                                />
                            </div>

                            <div className="space-y-2 md:col-span-2">
                                <Label htmlFor="item-desc">Description</Label>
                                <Textarea
                                    id="item-desc"
                                    value={currentitem.description || ""}
                                    onChange={(e) => setCurrentItem({ ...currentitem, description: e.target.value })}
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="item-category">Category</Label>
                                <select
                                    id="item-category"
                                    className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                    value={currentitem.category || ""}
                                    onChange={(e) => setCurrentItem({ ...currentitem, category: e.target.value })}
                                >
                                    <option value="" disabled>Select a category</option>
                                    <option value="Foods">Foods</option>
                                    <option value="Salads">Salads</option>
                                    <option value="Sweets">Sweets</option>
                                    <option value="Drinks">Drinks</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div className="space-y-2">
                                <Label>Visibility</Label>
                                <div className="flex items-center space-x-2">
                                    <Switch
                                        checked={currentitem.is_visible}
                                        onCheckedChange={(checked) => setCurrentItem({ ...currentitem, is_visible: checked })}
                                    />
                                    <span>{currentitem.is_visible ? "Visible" : "Hidden"}</span>
                                </div>
                            </div>

                            <div className="space-y-2 md:col-span-2">
                                <Label>Image</Label>
                                <ImageUpload
                                    value={currentitem.image_url || null}
                                    onUpload={async (file) => {
                                        try {
                                            const fileExt = file.name.split('.').pop();
                                            const fileName = `menu-items/${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;

                                            const { data, error } = await supabase.storage
                                                .from('images')
                                                .upload(fileName, file);

                                            if (error) {
                                                console.error('Upload error:', error);
                                                throw error;
                                            }

                                            const { data: { publicUrl } } = supabase.storage
                                                .from('images')
                                                .getPublicUrl(fileName);

                                            setCurrentItem({ ...currentitem, image_url: publicUrl });
                                            toast({ title: "Success", description: "Image uploaded successfully" });
                                        } catch (error: any) {
                                            toast({
                                                title: "Upload Failed",
                                                description: error.message || "Failed to upload image",
                                                variant: "destructive"
                                            });
                                        }
                                    }}
                                    onRemove={() => setCurrentItem({ ...currentitem, image_url: null })}
                                    isUploading={isLoading}
                                />
                                <Input
                                    placeholder="Or paste image URL"
                                    className="mt-2"
                                    value={currentitem.image_url || ""}
                                    onChange={(e) => setCurrentItem({ ...currentitem, image_url: e.target.value })}
                                />
                            </div>
                        </div>

                        <div className="flex justify-end pt-4">
                            <Button type="submit">{isEditing ? "Save Changes" : "Create Item"}</Button>
                        </div>
                    </form>
                ) : (
                    <div className="space-y-4">
                        <div className="flex justify-end">
                            <Button onClick={startCreate}>
                                <Plus className="w-4 h-4 mr-2" />
                                Add Item
                            </Button>
                        </div>

                        {isLoading ? (
                            <div className="flex justify-center py-8">
                                <Loader2 className="w-8 h-8 animate-spin" />
                            </div>
                        ) : (
                            <div className="rounded-md border">
                                <Table>
                                    <TableHeader>
                                        <TableRow>
                                            <TableHead>Image</TableHead>
                                            <TableHead>Name</TableHead>
                                            <TableHead>Price</TableHead>
                                            <TableHead>Category</TableHead>
                                            <TableHead>Status</TableHead>
                                            <TableHead className="text-right">Actions</TableHead>
                                        </TableRow>
                                    </TableHeader>
                                    <TableBody>
                                        {menuItems.length === 0 ? (
                                            <TableRow>
                                                <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                                                    No menu items found. Add one above.
                                                </TableCell>
                                            </TableRow>
                                        ) : (
                                            menuItems.map((item) => (
                                                <TableRow key={item.id}>
                                                    <TableCell>
                                                        {item.image_url && (
                                                            <div className="w-10 h-10 rounded-md overflow-hidden">
                                                                <img src={item.image_url} alt={item.name} className="w-full h-full object-cover" />
                                                            </div>
                                                        )}
                                                    </TableCell>
                                                    <TableCell className="font-medium">
                                                        <div>{item.name}</div>
                                                        {item.description && <div className="text-xs text-muted-foreground">{item.description.substring(0, 30)}...</div>}
                                                    </TableCell>
                                                    <TableCell>
                                                        {new Intl.NumberFormat('en-IQ', { style: 'currency', currency: 'IQD', maximumFractionDigits: 0 }).format(item.price || 0)}
                                                    </TableCell>
                                                    <TableCell>{item.category || '-'}</TableCell>
                                                    <TableCell>
                                                        <div className={cn("text-xs px-2 py-1 rounded-full inline-block", item.is_visible ? "bg-green-100 text-green-800" : "bg-gray-100 text-gray-800")}>
                                                            {item.is_visible ? "Visible" : "Hidden"}
                                                        </div>
                                                    </TableCell>
                                                    <TableCell className="text-right space-x-1">
                                                        <Button variant="ghost" size="icon" onClick={() => toggleVisibility(item)}>
                                                            {item.is_visible ? <Eye className="w-4 h-4" /> : <EyeOff className="w-4 h-4" />}
                                                        </Button>
                                                        <Button variant="ghost" size="icon" onClick={() => startEdit(item)}>
                                                            <Pencil className="w-4 h-4" />
                                                        </Button>
                                                        <Button variant="ghost" size="icon" className="text-destructive" onClick={() => handleDelete(item.id)}>
                                                            <Trash2 className="w-4 h-4" />
                                                        </Button>
                                                    </TableCell>
                                                </TableRow>
                                            ))
                                        )}
                                    </TableBody>
                                </Table>
                            </div>
                        )}
                    </div>
                )}
            </DialogContent>
        </Dialog>
    );
}
