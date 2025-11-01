import { Button } from "@/components/ui/button";
import { Menu } from "lucide-react";
import { useState } from "react";
import { Link } from "react-router-dom";
import logoEscola from "@/assets/logo-rangel-torres-new.png";

const navItems = [
  { label: "Início", href: "#home" },
  { label: "Tutoriais", href: "/tutoriais" },
  { label: "Contexto", href: "#context" },
  { label: "Dados", href: "#data" },
  { label: "Projeto", href: "#about" },
  { label: "Construção", href: "#construction" },
  { label: "Inclusão", href: "#inclusion" },
  { label: "Apresentação", href: "#presentation" },
  { label: "Software", href: "#software" },
  { label: "Equipe", href: "#team" },
];

export const Navigation = () => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-background/90 backdrop-blur-xl border-b border-border/50 shadow-lg" role="navigation" aria-label="Navegação principal">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-3 md:py-4 lg:py-5">
        <div className="flex items-center justify-between">
          <div className="flex items-center">
            <a href="#home" className="transition-all duration-300 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-primary/50 rounded-lg">
              <img
                src={logoEscola}
                alt="Rangel Torres Escola Estadual"
                className="h-14 sm:h-16 md:h-16 lg:h-18 xl:h-22 w-auto drop-shadow-2xl"
              />
            </a>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center gap-1 xl:gap-2">
            {navItems.map((item) => (
              item.href.startsWith('#') ? (
                <a
                  key={item.href}
                  href={item.href}
                  className="text-xs xl:text-sm font-medium text-foreground/80 hover:text-primary transition-all duration-300 px-3 py-2 rounded-lg hover:bg-primary/5 relative group"
                >
                  <span className="relative z-10">{item.label}</span>
                  <span className="absolute inset-x-0 bottom-0 h-0.5 bg-primary scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></span>
                </a>
              ) : (
                <Link
                  key={item.href}
                  to={item.href}
                  className="text-xs xl:text-sm font-medium text-foreground/80 hover:text-primary transition-all duration-300 px-3 py-2 rounded-lg hover:bg-primary/5 relative group"
                >
                  <span className="relative z-10">{item.label}</span>
                  <span className="absolute inset-x-0 bottom-0 h-0.5 bg-primary scale-x-0 group-hover:scale-x-100 transition-transform duration-300 origin-left"></span>
                </Link>
              )
            ))}
          </div>

          {/* Mobile Menu Button */}
          <Button
            variant="ghost"
            size="icon"
            className="lg:hidden hover:bg-secondary"
            onClick={() => setIsOpen(!isOpen)}
            aria-label="Menu de navegação"
            aria-expanded={isOpen}
          >
            <Menu className="h-5 w-5" />
          </Button>
        </div>

        {/* Mobile Navigation */}
        {isOpen && (
          <div className="lg:hidden mt-4 pb-4 flex flex-col gap-2 animate-fade-in bg-secondary/30 rounded-lg p-4">
            {navItems.map((item) => (
              item.href.startsWith('#') ? (
                <a
                  key={item.href}
                  href={item.href}
                  className="text-sm font-medium text-foreground hover:text-primary transition-colors py-2 px-3 rounded-md hover:bg-secondary"
                  onClick={() => setIsOpen(false)}
                >
                  {item.label}
                </a>
              ) : (
                <Link
                  key={item.href}
                  to={item.href}
                  className="text-sm font-medium text-foreground hover:text-primary transition-colors py-2 px-3 rounded-md hover:bg-secondary"
                  onClick={() => setIsOpen(false)}
                >
                  {item.label}
                </Link>
              )
            ))}
          </div>
        )}
      </div>
    </nav>
  );
};
