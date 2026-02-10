import { StarRating } from "./StarRating";
import { formatDistanceToNow } from "date-fns";
import { useState } from "react";
import { Dialog, DialogContent, DialogTrigger } from "@/components/ui/dialog";

interface ReviewCardProps {
  userName?: string;
  userAvatar?: string | null;
  rating: number;
  comment?: string;
  createdAt: string;
  photos?: string[];
}

export function ReviewCard({
  userName,
  userAvatar,
  rating,
  comment,
  createdAt,
  photos = [],
}: ReviewCardProps) {
  const [selectedPhoto, setSelectedPhoto] = useState<string | null>(null);

  return (
    <div className="bg-card border border-border rounded-xl p-4 shadow-soft">
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center overflow-hidden shrink-0">
            {userAvatar ? (
              <img src={userAvatar} alt={userName} className="w-full h-full object-cover" />
            ) : (
              <span className="text-sm font-medium text-primary">
                {userName?.[0]?.toUpperCase() || "U"}
              </span>
            )}
          </div>
          <div>
            <p className="font-medium text-sm">{userName || "Anonymous"}</p>
            <p className="text-xs text-muted-foreground">
              {formatDistanceToNow(new Date(createdAt), { addSuffix: true })}
            </p>
          </div>
        </div>
        <StarRating rating={rating} size="sm" />
      </div>
      {comment && (
        <p className="text-sm text-muted-foreground leading-relaxed mb-4">
          {comment}
        </p>
      )}

      {photos.length > 0 && (
        <div className="flex flex-wrap gap-2 mt-3">
          {photos.map((photo, index) => (
            <Dialog key={index}>
              <DialogTrigger asChild>
                <div className="relative w-24 h-24 rounded-lg overflow-hidden cursor-pointer border border-border hover:opacity-90 transition-opacity">
                  <img
                    src={photo}
                    alt={`Review photo ${index + 1}`}
                    className="w-full h-full object-cover"
                  />
                </div>
              </DialogTrigger>
              <DialogContent className="max-w-3xl p-0 overflow-hidden bg-black/90 border-none">
                <img
                  src={photo}
                  alt={`Review photo ${index + 1}`}
                  className="w-full h-auto max-h-[85vh] object-contain"
                />
              </DialogContent>
            </Dialog>
          ))}
        </div>
      )}
    </div>
  );
}
