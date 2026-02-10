import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { ImageUpload } from "@/components/ui/image-upload";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Plus } from "lucide-react";

interface Category {
    id: string;
    name: string;
    slug: string;
    description: string | null;
    image_url: string | null;
    category_type?: 'standard' | 'province' | 'district' | 'vertical';
    parent_id?: string | null;
}

interface CreateCategoryDialogProps {
    categories: Category[];
    onSuccess: () => void;
    existingCategory?: Category | null;
    open: boolean;
    onOpenChange: (open: boolean) => void;
    defaultParentId?: string | null;
    defaultType?: 'standard' | 'province' | 'district' | 'vertical';
}

export function CreateCategoryDialog({
    categories,
    onSuccess,
    existingCategory,
    open,
    onOpenChange,
    defaultParentId,
    defaultType
}: CreateCategoryDialogProps) {
    const { toast } = useToast();
    const [isUploading, setIsUploading] = useState(false);
    const [formData, setFormData] = useState<Partial<Category>>({
        category_type: defaultType || 'province',
        parent_id: defaultParentId || null,
        name: '',
        description: '',
        image_url: ''
    });

    useEffect(() => {
        if (existingCategory) {
            setFormData(existingCategory);
        } else {
            setFormData({
                category_type: defaultType || 'province',
                parent_id: defaultParentId || null,
                name: '',
                description: '',
                image_url: ''
            });
        }
    }, [existingCategory, open, defaultType, defaultParentId]);

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        try {
            const slug = formData.name?.toLowerCase().replace(/ /g, "-") || "";
            const payload = { ...formData, slug };

            if (!payload.name) throw new Error("Name is required");

            // Clean up payload based on type
            if (payload.category_type === 'province') {
                payload.parent_id = null;
            }

            let error;
            let newCategoryId;

            if (existingCategory) {
                const { error: updateError } = await supabase
                    .from("categories")
                    .update(payload as any)
                    .eq("id", existingCategory.id);
                error = updateError;
            } else {
                const { data, error: insertError } = await supabase
                    .from("categories")
                    .insert([payload as any])
                    .select()
                    .single();
                error = insertError;
                if (data) newCategoryId = data.id;
            }

            if (error) throw error;

            // Automatic Vertical Creation for New Districts
            if (!existingCategory && formData.category_type === 'district' && newCategoryId) {
                const verticals = [
                    { name: 'Restaurants', image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800' },
                    { name: 'Markets', image: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800' },
                    { name: 'Mechanics', image: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800' },
                    { name: 'Mobile Shops', image: 'https://images.unsplash.com/photo-1596742578505-1c3906352936?w=800' },
                    { name: 'Candy Shop', image: 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=800' }
                ];

                const verticalInserts = verticals.map(v => ({
                    name: v.name,
                    slug: `${slug}-${v.name.toLowerCase().replace(/ /g, '-')}`,
                    category_type: 'vertical',
                    parent_id: newCategoryId,
                    image_url: v.image
                }));

                const { error: verticalError } = await supabase
                    .from("categories")
                    .insert(verticalInserts);

                if (verticalError) {
                    console.error("Error creating default verticals:", verticalError);
                    toast({ title: "Warning", description: "District created but failed to create default verticals.", variant: "destructive" });
                } else {
                    toast({ title: "Success", description: "District and default verticals created successfully." });
                }
            } else {
                toast({ title: "Success", description: `Category ${existingCategory ? "updated" : "created"}.` });
            }

            onSuccess();
            onOpenChange(false);
        } catch (error: any) {
            toast({ title: "Error", description: error.message, variant: "destructive" });
        }
    };

    // Filter potential parents based on selected type
    const availableParents = categories.filter(c => {
        if (formData.category_type === 'district') return c.category_type === 'province';
        if (formData.category_type === 'vertical') return c.category_type === 'district';
        return false;
    });

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            {!existingCategory && (
                <DialogTrigger asChild>
                    <Button>
                        <Plus className="w-4 h-4 mr-2" />
                        Add Category
                    </Button>
                </DialogTrigger>
            )}
            <DialogContent className="max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>{existingCategory ? "Edit Category" : "Add New Category"}</DialogTitle>
                </DialogHeader>
                <form onSubmit={handleSave} className="space-y-4">
                    <div className="space-y-2">
                        <Label>Type</Label>
                        <select
                            className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                            value={formData.category_type || 'province'}
                            onChange={(e) => setFormData({ ...formData, category_type: e.target.value as any, parent_id: null })}
                            disabled={!!existingCategory} // Prevent changing hierarchy level on edit for safety for now
                        >
                            <option value="province">Province (Top Level)</option>
                            <option value="district">District (Under Province)</option>
                            <option value="vertical">Vertical (Under District)</option>
                            <option value="standard">Standard (Legacy)</option>
                        </select>
                    </div>

                    {(formData.category_type === 'district' || (formData.category_type === 'vertical' && defaultParentId)) && (
                        <div className="space-y-2">
                            <Label>Parent Category</Label>
                            <select
                                className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                                value={formData.parent_id || ""}
                                onChange={(e) => setFormData({ ...formData, parent_id: e.target.value })}
                                required
                            >
                                <option value="">Select Parent...</option>
                                {availableParents.map(parent => (
                                    <option key={parent.id} value={parent.id}>
                                        {parent.name}
                                    </option>
                                ))}
                            </select>
                        </div>
                    )}

                    <div className="space-y-2">
                        <Label>Name</Label>
                        <Input
                            value={formData.name || ""}
                            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label>Description</Label>
                        <Textarea
                            value={formData.description || ""}
                            onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                        />
                    </div>

                    <div className="space-y-2">
                        <Label>Image</Label>
                        <ImageUpload
                            value={formData.image_url || null}
                            onUpload={async (file) => {
                                setIsUploading(true);
                                try {
                                    const fileExt = file.name.split('.').pop();
                                    const fileName = `categories/${Date.now()}-${Math.random().toString(36).substring(2)}.${fileExt}`;
                                    const { error } = await supabase.storage.from('images').upload(fileName, file);
                                    if (error) throw error;
                                    const { data: { publicUrl } } = supabase.storage.from('images').getPublicUrl(fileName);
                                    setFormData({ ...formData, image_url: publicUrl });
                                    toast({ title: "Image uploaded" });
                                } catch (error: any) {
                                    toast({ title: "Upload Failed", description: error.message, variant: "destructive" });
                                } finally {
                                    setIsUploading(false);
                                }
                            }}
                            onRemove={() => setFormData({ ...formData, image_url: null })}
                            isUploading={isUploading}
                        />
                    </div>

                    <div className="flex justify-end gap-2">
                        <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>Cancel</Button>
                        <Button type="submit">{existingCategory ? "Update" : "Create"}</Button>
                    </div>
                </form>
            </DialogContent>
        </Dialog>
    );
}
