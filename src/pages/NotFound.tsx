import { useLocation } from "react-router-dom";
import { useEffect } from "react";
import { Button } from "@/components/ui/button";

const NotFound = () => {
  const location = useLocation();

  useEffect(() => {
    console.error("404 Error: User attempted to access non-existent route:", location.pathname);
  }, [location.pathname]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background">
      <div className="text-center space-y-6 px-4">
        <h1 className="text-6xl md:text-8xl font-bold text-primary">404</h1>
        <p className="text-xl md:text-2xl text-foreground">Oops! Página não encontrada</p>
        <p className="text-muted-foreground">A página que você está procurando não existe.</p>
        <Button asChild size="lg">
          <a href="/">Voltar para Home</a>
        </Button>
      </div>
    </div>
  );
};

export default NotFound;
