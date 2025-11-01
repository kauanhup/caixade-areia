import { Button } from "@/components/ui/button";
import { ArrowDown } from "lucide-react";
import { Link } from "react-router-dom";
import heroImage from "@/assets/hero-sandbox.jpg";
import equipePodcast from "@/assets/equipe-podcast-hero.jpg";

export const Hero = () => {
  return (
    <section
      id="home"
      className="min-h-screen flex items-center justify-center relative bg-hero-gradient pt-20 md:pt-24 lg:pt-28 overflow-hidden"
      role="banner"
      aria-label="Seção principal do projeto Caixa de Areia"
    >
      <div className="absolute inset-0">
        <img
          src={heroImage}
          alt="Caixa de areia interativa demonstrando fluxo de água"
          className="w-full h-full object-cover opacity-15 blur-[2px]"
          loading="eager"
          fetchPriority="high"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-background/85 via-background/75 to-background/70" />
      </div>

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 md:py-20 relative z-10">
        <div className="max-w-5xl mx-auto text-center space-y-8">
          <header className="space-y-4 animate-fade-in">
            <h1 className="text-4xl sm:text-5xl md:text-6xl lg:text-7xl xl:text-8xl font-bold text-primary leading-tight tracking-tight">
              Caixa de Areia Interativa
            </h1>
            <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/10 backdrop-blur-sm rounded-full border border-primary/20">
              <span className="text-base sm:text-lg md:text-xl font-semibold text-primary">STEAM MT 2025</span>
            </div>
          </header>

          <div className="my-8 sm:my-10 md:my-12 max-w-sm sm:max-w-md md:max-w-3xl mx-auto group">
            <div className="rounded-2xl overflow-hidden shadow-2xl ring-1 ring-primary/10 transition-all duration-300 group-hover:shadow-primary/20 group-hover:scale-[1.02]">
              <img
                src={equipePodcast}
                alt="Equipe do projeto Caixa de Areia reunida para gravação de podcast"
                className="w-full h-auto object-cover"
                loading="eager"
                fetchPriority="high"
              />
            </div>
          </div>

          <p className="text-lg sm:text-xl md:text-2xl text-foreground/80 mb-8 sm:mb-10 max-w-xs sm:max-w-xl md:max-w-3xl mx-auto px-4 leading-relaxed font-light">
            Tecnologia, inclusão e aprendizado para compreender e proteger nosso meio ambiente
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center px-4">
            <Button asChild size="lg" className="text-base sm:text-lg w-full sm:w-auto shadow-lg hover:shadow-2xl hover:scale-105 transition-all duration-300">
              <Link to="/tutoriais">
                <span>Passo a Passo</span>
              </Link>
            </Button>
            <Button asChild size="lg" variant="outline" className="text-base sm:text-lg w-full sm:w-auto shadow-lg hover:shadow-2xl hover:scale-105 transition-all duration-300 border-2">
              <a href="#software">Baixar Software</a>
            </Button>
          </div>

          <div className="mt-12 sm:mt-16">
            <a 
              href="#context" 
              className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary/10 backdrop-blur-sm border border-primary/20 animate-bounce hover:bg-primary/20 transition-colors" 
              aria-label="Rolar para próxima seção"
            >
              <ArrowDown className="h-5 w-5 text-primary" />
            </a>
          </div>
        </div>
      </div>
    </section>
  );
};
