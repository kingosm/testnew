import React, { useRef } from "react";
import { Button } from "./button";
import { Loader2, Upload, X, Image as ImageIcon } from "lucide-react";
import { cn } from "@/lib/utils";

interface MultiImageUploadProps {
    value?: string[];
    onUpload: (files: File[]) => Promise<void>;
    onRemove: (url: string) => void;
    isUploading: boolean;
    className?: string;
    maxFiles?: number;
}

export function MultiImageUpload({
    value = [],
    onUpload,
    onRemove,
    isUploading,
    className,
    maxFiles = 4
}: MultiImageUploadProps) {
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleClick = () => {
        fileInputRef.current?.click();
    };

    const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = Array.from(e.target.files || []);
        if (files.length > 0) {
            // Check if adding these files exceeds maxFiles
            if (value.length + files.length > maxFiles) {
                alert(`You can only upload a maximum of ${maxFiles} photos.`);
                return;
            }
            await onUpload(files);
        }
        // Reset input value to allow same file re-upload if needed
        e.target.value = "";
    };

    return (
        <div className={cn("space-y-4 w-full", className)}>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {value.map((url, index) => (
                    <div key={url} className="relative group aspect-square rounded-xl overflow-hidden border border-border shadow-sm">
                        <img
                            src={url}
                            alt={`Uploaded ${index + 1}`}
                            className="w-full h-full object-cover"
                        />
                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                            <Button
                                type="button"
                                variant="destructive"
                                size="icon"
                                onClick={(e) => {
                                    e.stopPropagation();
                                    onRemove(url);
                                }}
                                className="h-8 w-8 rounded-full"
                            >
                                <X className="h-4 w-4" />
                            </Button>
                        </div>
                    </div>
                ))}

                {value.length < maxFiles && (
                    <div
                        onClick={!isUploading ? handleClick : undefined}
                        className={cn(
                            "relative flex flex-col items-center justify-center gap-2 aspect-square rounded-xl border-2 border-dashed transition-all duration-300 bg-muted/30",
                            !isUploading && "cursor-pointer hover:border-primary hover:bg-muted/50 border-muted-foreground/25",
                            isUploading && "opacity-60 cursor-not-allowed"
                        )}
                    >
                        {isUploading ? (
                            <Loader2 className="h-6 w-6 animate-spin text-primary" />
                        ) : (
                            <>
                                <div className="p-2 rounded-full bg-primary/10 text-primary">
                                    <Upload className="h-4 w-4" />
                                </div>
                                <p className="text-xs font-medium text-muted-foreground">Add Photo</p>
                            </>
                        )}
                    </div>
                )}
            </div>

            <input
                type="file"
                ref={fileInputRef}
                className="hidden"
                accept="image/*"
                multiple
                onChange={handleFileChange}
                disabled={isUploading}
            />
        </div>
    );
}
