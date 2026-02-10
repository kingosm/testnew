import { useLocation, Link } from "react-router-dom";
import { useEffect } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { MapPin } from "lucide-react";

const NotFound = () => {
  const location = useLocation();
  const { t } = useLanguage();

  useEffect(() => {
    console.error("404 Error: User attempted to access non-existent route:", location.pathname);
  }, [location.pathname]);

  return (
    <Layout>
      <div className="min-h-screen flex items-center justify-center py-24 px-6 relative overflow-hidden bg-background">
        {/* Background Patterns */}
        <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-primary/10 rounded-full blur-[120px] -mr-64 -mt-64" />
        <div className="absolute bottom-0 left-0 w-[600px] h-[600px] bg-amber-500/5 rounded-full blur-[120px] -ml-64 -mb-64" />

        <div className="text-center relative z-10 animate-reveal">
          <div className="w-24 h-24 rounded-[2rem] bg-secondary/50 flex items-center justify-center mx-auto mb-12 border border-border/50 shadow-2xl">
            <MapPin className="w-12 h-12 text-primary opacity-50" />
          </div>

          <h1 className="text-7xl md:text-9xl font-black mb-6 tracking-tighter leading-none opacity-20">404</h1>
          <h2 className="text-4xl md:text-6xl font-black mb-6 tracking-tight leading-tight">
            {t('notfound.title')}
          </h2>
          <p className="text-xl md:text-2xl text-muted-foreground font-medium mb-12 max-w-lg mx-auto leading-relaxed">
            {t('notfound.desc')}
          </p>

          <Button asChild className="hero-gradient px-12 h-18 rounded-2xl font-black border-none shadow-2xl shadow-primary/30 transition-all text-white text-lg">
            <Link to="/">
              {t('notfound.return')}
            </Link>
          </Button>
        </div>
      </div>
    </Layout>
  );
};


export default NotFound;
