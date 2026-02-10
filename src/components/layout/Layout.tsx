import { Header } from "./Header";
import { Footer } from "./Footer";

interface LayoutProps {
  children: React.ReactNode;
}

export function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen flex flex-col bg-background selection:bg-primary/30">
      <Header />
      <main className="flex-1 transition-all duration-500">
        {children}
      </main>
      <Footer />
    </div>
  );
}

