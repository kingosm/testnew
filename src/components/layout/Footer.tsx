import { Link } from "react-router-dom";
import { MapPin, Mail, Phone } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-background border-t border-border/50 relative overflow-hidden">
      {/* Background patterns */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-primary/10 rounded-full blur-[100px] -mr-48 -mt-48" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-indigo-500/5 rounded-full blur-[100px] -ml-48 -mb-48" />

      <div className="container mx-auto px-6 py-24 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-16">
          {/* Brand */}
          <div className="lg:col-span-5 space-y-8">
            <Link to="/" className="flex items-center gap-4 group">
              <div className="w-14 h-14 rounded-2xl bg-primary flex items-center justify-center shadow-2xl transition-all duration-500">
                <MapPin className="w-7 h-7 text-white" />
              </div>
              <div className="flex flex-col">
                <span className="text-3xl font-black tracking-tighter text-foreground">
                  KURDISTAN<span className="text-primary">PLACES</span>
                </span>
                <span className="text-[10px] uppercase tracking-[0.4em] font-black text-primary opacity-70">
                  Global Discovery
                </span>
              </div>
            </Link>
            <p className="text-lg text-muted-foreground max-w-md font-medium leading-relaxed">
              Mapping the finest destinations across Kurdistan. Join our world-class directory of handpicked locations and hidden gems.
            </p>
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-xl bg-secondary flex items-center justify-center hover:bg-primary hover:text-white transition-all cursor-pointer">
                <Mail className="w-5 h-5" />
              </div>
              <div className="w-12 h-12 rounded-xl bg-secondary flex items-center justify-center hover:bg-primary hover:text-white transition-all cursor-pointer">
                <Phone className="w-5 h-5" />
              </div>
            </div>
          </div>

          {/* Quick Links */}
          <div className="lg:col-span-3 lg:col-start-7">
            <h4 className="text-xs font-black mb-8 uppercase tracking-[0.3em] text-primary">
              Navigation
            </h4>
            <nav className="flex flex-col gap-6">
              <Link
                to="/"
                className="text-lg font-bold text-muted-foreground hover:text-foreground transition-all hover:translate-x-2"
              >
                Explore Home
              </Link>
              <Link
                to="/categories"
                className="text-lg font-bold text-muted-foreground hover:text-foreground transition-all hover:translate-x-2"
              >
                Browse Categories
              </Link>
              <Link
                to="/nearby"
                className="text-lg font-bold text-muted-foreground hover:text-foreground transition-all hover:translate-x-2"
              >
                Find Local Places
              </Link>
              <Link
                to="/auth"
                className="text-lg font-bold text-muted-foreground hover:text-foreground transition-all hover:translate-x-2"
              >
                Partner with us
              </Link>
            </nav>
          </div>

          {/* Contact & Support */}
          <div className="lg:col-span-3">
            <h4 className="text-xs font-black mb-8 uppercase tracking-[0.3em] text-primary">
              Get in Touch
            </h4>
            <div className="flex flex-col gap-8">
              <div className="group">
                <span className="text-[10px] uppercase tracking-widest font-black text-muted-foreground block mb-2 opacity-50">Email Support</span>
                <a
                  href="mailto:contact@kurdistanplaces.com"
                  className="text-xl font-black text-foreground hover:text-primary transition-colors"
                >
                  contact@kurdistanplaces.com
                </a>
              </div>
              <div className="group">
                <span className="text-[10px] uppercase tracking-widest font-black text-muted-foreground block mb-2 opacity-50">Member Services</span>
                <a
                  href="tel:+9647500000000"
                  className="text-xl font-black text-foreground hover:text-primary transition-colors"
                >
                  +964 750 000 0000
                </a>
              </div>
            </div>
          </div>
        </div>

        <div className="mt-24 pt-12 border-t border-white/5 flex flex-col md:flex-row items-center justify-between gap-6">
          <p className="text-[10px] font-black text-muted-foreground uppercase tracking-[0.2em] opacity-40">
            © {new Date().getFullYear()} Kurdistan Places. The Ultimate Discovery Guide.
          </p>
          <div className="flex items-center gap-8 text-[10px] font-black uppercase tracking-widest text-muted-foreground opacity-40">
            <a href="#" className="hover:text-primary transition-colors">Privacy Policy</a>
            <a href="#" className="hover:text-primary transition-colors">Terms of Service</a>
            <a href="#" className="hover:text-primary transition-colors">Safety</a>
          </div>
        </div>
      </div>
    </footer>
  );
}

