import { useState, useEffect, useCallback } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useLanguage } from "@/contexts/LanguageContext";
import { Layout } from "@/components/layout/Layout";
import { RestaurantCard } from "@/components/restaurants/RestaurantCard";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import type { User } from "@supabase/supabase-js";
import { Heart } from "lucide-react";

interface Restaurant {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  image_url: string | null;
  address: string | null;
  avg_rating?: number;
  review_count?: number;
}

const FavoritesPage = () => {
  const { t } = useLanguage();
  const [user, setUser] = useState<User | null>(null);
  const [favorites, setFavorites] = useState<Restaurant[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!session?.user) {
        navigate("/auth");
        return;
      }
      setUser(session.user);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event, session) => {
        if (!session?.user) {
          navigate("/auth");
          return;
        }
        setUser(session.user);
      }
    );

    return () => subscription.unsubscribe();
  }, [navigate]);

  const fetchFavorites = useCallback(async () => {
    if (!user) return;

    const { data: favoritesData } = await (supabase as any)
      .from("favorites")
      .select(`
        restaurant_id,
        restaurants (*)
      `)
      .eq("user_id", user.id);

    if (favoritesData) {
      const restaurants = await Promise.all(
        favoritesData
          .filter((f) => f.restaurants && (f.restaurants as any).is_visible)
          .map(async (f) => {
            const restaurant = f.restaurants as unknown as Restaurant;

            const { data: reviews } = await supabase
              .from("reviews")
              .select("rating")
              .eq("restaurant_id", restaurant.id);

            const reviewCount = reviews?.length || 0;
            const avgRating =
              reviewCount > 0
                ? reviews!.reduce((sum, r) => sum + r.rating, 0) / reviewCount
                : 0;

            return { ...restaurant, avg_rating: avgRating, review_count: reviewCount };
          })
      );
      setFavorites(restaurants);
    }

    setIsLoading(false);
  }, [user]);

  useEffect(() => {
    if (user) {
      fetchFavorites();
    }
  }, [user, fetchFavorites]);

  if (!user) {
    return null;
  }

  return (
    <Layout>
      <section className="pt-40 pb-24 bg-background overflow-hidden relative">
        <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-primary/5 rounded-full blur-[120px] -mr-64 -mt-64" />

        <div className="container mx-auto px-6 relative z-10">
          <div className="mb-20 animate-reveal">
            <div className="inline-flex items-center px-4 py-1 rounded-full bg-rose-500 text-white text-[10px] font-black uppercase tracking-[0.2em] shadow-[0_0_20px_rgba(244,63,94,0.3)] mb-6">
              {t('favorites.badge.premium')}
            </div>
            <h1 className="text-5xl md:text-7xl font-black mb-6 tracking-tighter leading-none">
              {t('favorites.title')}
            </h1>
            <p className="text-xl md:text-2xl text-muted-foreground font-medium max-w-2xl leading-relaxed">
              {t('favorites.subtitle')}
            </p>
          </div>

          {isLoading ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 md:gap-10">
              {[1, 2, 3].map((i) => (
                <div
                  key={i}
                  className="aspect-[4/3] rounded-[2.5rem] bg-secondary/50 animate-pulse border border-border/50"
                />
              ))}
            </div>
          ) : favorites.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 md:gap-10">
              {favorites.map((restaurant, idx) => (
                <div key={restaurant.id} className="animate-reveal" style={{ animationDelay: `${idx * 0.1}s` }}>
                  <RestaurantCard
                    id={restaurant.id}
                    name={restaurant.name}
                    slug={restaurant.slug}
                    description={restaurant.description || undefined}
                    imageUrl={restaurant.image_url || undefined}
                    address={restaurant.address || undefined}
                    rating={restaurant.avg_rating}
                    reviewCount={restaurant.review_count}
                  />
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-32 glass-card rounded-[3rem] border-white/5 max-w-2xl mx-auto flex flex-col items-center">
              <div className="w-24 h-24 bg-rose-500/10 rounded-full flex items-center justify-center mb-8">
                <Heart className="w-10 h-10 text-rose-500 opacity-50" />
              </div>
              <h2 className="text-3xl font-black mb-4 tracking-tight">
                {t('favorites.empty.title')}
              </h2>
              <p className="text-lg text-muted-foreground font-medium mb-10 max-w-md">
                {t('favorites.empty.desc')}
              </p>
              <Button asChild className="hero-gradient px-10 h-16 rounded-2xl font-black border-none shadow-2xl shadow-primary/30 transition-all text-white">
                <Link to="/nearby">{t('favorites.empty.btn')}</Link>
              </Button>
            </div>
          )}
        </div>
      </section>
    </Layout>
  );
};


export default FavoritesPage;
