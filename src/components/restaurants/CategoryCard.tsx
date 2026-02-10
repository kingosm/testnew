import { Link } from "react-router-dom";
import { ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";

interface CategoryCardProps {
  name: string;
  slug: string;
  description?: string;
  imageUrl?: string;
  restaurantCount?: number;
  className?: string;
  variant?: "default" | "circular";
}

export function CategoryCard({
  name,
  slug,
  description,
  imageUrl,
  restaurantCount = 0,
  className,
  variant = "default",
}: CategoryCardProps) {
  if (variant === "circular") {
    return (
      <Link
        to={`/category/${slug}`}
        className={cn(
          "group flex flex-col items-center gap-6 transition-all duration-500",
          className
        )}
      >
        <div className="relative w-48 h-48 md:w-56 md:h-56">
          {/* Glowing Animated Rings */}
          <div className="absolute inset-0 rounded-full border border-primary/20 scale-110 group-hover:scale-125 transition-transform duration-700 ease-out" />
          <div className="absolute inset-0 rounded-full border border-primary/10 scale-125 group-hover:scale-150 transition-transform duration-1000 ease-out delay-75" />

          <div className="relative w-full h-full bg-secondary rounded-full overflow-hidden border-2 border-white/10 shadow-2xl transition-all duration-500 group-hover:border-primary/50 group-hover:shadow-[0_0_40px_rgba(99,102,241,0.3)]">
            <img
              src={imageUrl || "/placeholder.svg"}
              alt={name}
              className="w-full h-full object-cover transition-transform duration-[1.5s]"
            />
            <div className="absolute inset-0 bg-primary/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />

            {/* Center Count */}
            <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-500">
              <span className="bg-background/90 backdrop-blur-md px-4 py-1 rounded-full text-[10px] font-black uppercase tracking-widest text-primary border border-primary/20">
                {restaurantCount} Places
              </span>
            </div>
          </div>
        </div>

        <div className="text-center space-y-2 relative">
          <h3 className="text-xl md:text-2xl font-black tracking-tighter group-hover:text-primary transition-colors">
            {name}
          </h3>
          <div className="w-12 h-1 bg-primary/20 rounded-full mx-auto group-hover:w-24 group-hover:bg-primary transition-all duration-500" />
        </div>
      </Link>
    );
  }

  return (
    <Link
      to={`/category/${slug}`}
      className={cn(
        "group relative block h-64 overflow-hidden rounded-[2.5rem] border border-white/5",
        className
      )}
    >
      <div className="absolute inset-0 bg-secondary">
        <img
          src={imageUrl || "/placeholder.svg"}
          alt={name}
          className="w-full h-full object-cover opacity-60 transition-transform duration-700 group-hover:opacity-40"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-background via-background/20 to-transparent" />
        <div className="absolute inset-0 bg-primary/10 opacity-0 group-hover:opacity-100 transition-opacity duration-500 mix-blend-overlay" />
      </div>

      <div className="relative h-full flex flex-col justify-end p-8 md:p-10 z-10">
        <div className="space-y-4 translate-y-2 group-hover:translate-y-0 transition-transform duration-500">
          <div className="flex items-center gap-3">
            <span className="bg-white/10 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest text-white border border-white/10">
              {restaurantCount} Premium Spots
            </span>
          </div>

          <div className="space-y-2">
            <h3 className="text-3xl md:text-5xl font-black tracking-tighter text-white leading-[0.9]">
              {name}
            </h3>
            <p className="text-sm font-medium text-gray-300 opacity-0 group-hover:opacity-100 transition-opacity duration-500 delay-100 max-w-xs leading-relaxed">
              {description || "Explore curated collections of the best dining experiences."}
            </p>
          </div>

          <div className="pt-4 flex items-center gap-4 opacity-70 group-hover:opacity-100 transition-opacity duration-500">
            <span className="text-xs font-bold uppercase tracking-widest text-primary">Discover</span>
            <div className="w-12 h-px bg-primary/50 group-hover:w-20 transition-all duration-500" />
            <ChevronRight className="w-5 h-5 text-primary transition-transform group-hover:translate-x-2" />
          </div>
        </div>
      </div>
    </Link>
  );
}

