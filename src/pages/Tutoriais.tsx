import { Navigation } from "@/components/Navigation";
import { Section } from "@/components/Section";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Youtube } from "lucide-react";
import { Link } from "react-router-dom";
import logoSeducMT from "@/assets/logo-seduc-mt.png";
import logoDRECaceres from "@/assets/logo-dre-caceres.png";

const Tutoriais = () => {
  return (
    <div className="min-h-screen">
      <Navigation />

      <div className="pt-24 md:pt-28 lg:pt-32">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 mb-8">
          <Button asChild variant="outline" size="lg">
            <Link to="/" className="inline-flex items-center gap-2">
              <ArrowLeft className="h-4 w-4" />
              Voltar para Home
            </Link>
          </Button>
        </div>

        <Section id="tutoriais" title="Tutoriais - Passo a Passo">
          <div className="max-w-4xl mx-auto">
            <div className="bg-primary/5 border-2 border-primary/20 rounded-xl p-6 sm:p-8 md:p-10 text-center mb-8 sm:mb-12">
              <p className="text-lg sm:text-xl text-foreground">
                Assista aos vídeos tutoriais completos e aprenda a construir, instalar e calibrar sua própria caixa de areia interativa!
              </p>
            </div>

            <div className="grid gap-6 sm:gap-8 md:grid-cols-3">
              <div className="bg-card border-2 border-border rounded-lg p-6 text-center">
                <div className="text-3xl sm:text-4xl font-bold text-primary mb-3">1</div>
                <h4 className="text-lg font-semibold mb-3">Construção da Caixa</h4>
                <p className="text-sm text-muted-foreground mb-4">Passo a passo completo da construção</p>
                <Button asChild size="lg" className="w-full">
                  <a 
                    href="https://www.youtube.com/watch?v=odsFuhwKoLk" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="inline-flex items-center justify-center gap-2"
                  >
                    <Youtube className="h-5 w-5" />
                    Assistir no YouTube
                  </a>
                </Button>
              </div>

              <div className="bg-card border-2 border-border rounded-lg p-6 text-center">
                <div className="text-3xl sm:text-4xl font-bold text-primary mb-3">2</div>
                <h4 className="text-lg font-semibold mb-3">Instalação do Software</h4>
                <p className="text-sm text-muted-foreground mb-4">Como instalar e configurar o sistema</p>
                <Button asChild size="lg" className="w-full">
                  <a 
                    href="https://www.youtube.com/watch?v=1KjBcGAjzKU" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="inline-flex items-center justify-center gap-2"
                  >
                    <Youtube className="h-5 w-5" />
                    Assistir no YouTube
                  </a>
                </Button>
              </div>

              <div className="bg-card border-2 border-border rounded-lg p-6 text-center">
                <div className="text-3xl sm:text-4xl font-bold text-primary mb-3">3</div>
                <h4 className="text-lg font-semibold mb-3">Calibrando</h4>
                <p className="text-sm text-muted-foreground mb-4">Calibração e ajustes finais</p>
                <Button asChild size="lg" className="w-full">
                  <a 
                    href="https://www.youtube.com/watch?v=_teWu55DVjw" 
                    target="_blank" 
                    rel="noopener noreferrer"
                    className="inline-flex items-center justify-center gap-2"
                  >
                    <Youtube className="h-5 w-5" />
                    Assistir no YouTube
                  </a>
                </Button>
              </div>
            </div>
          </div>
        </Section>
      </div>

      {/* Footer */}
      <footer className="bg-accent text-accent-foreground py-8 sm:py-12 md:py-16">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h3 className="text-xl sm:text-2xl md:text-3xl font-bold mb-3 sm:mb-4">Caixa de Areia</h3>
          <p className="text-accent-foreground/80 mb-4 sm:mb-6 text-sm sm:text-base">
            STEAM MT 2025 - Tecnologia, inclusão e aprendizado
          </p>
          <div className="flex flex-wrap justify-center items-center gap-6 sm:gap-8 md:gap-10 mb-6 sm:mb-8">
            <img
              src={logoSeducMT}
              alt="Logo SEDUC MT"
              className="h-12 sm:h-14 md:h-16 w-auto object-contain"
              loading="lazy"
            />
            <img
              src={logoDRECaceres}
              alt="Logo DRE Cáceres"
              className="h-12 sm:h-14 md:h-16 w-auto object-contain"
              loading="lazy"
            />
          </div>
          <div className="flex justify-center gap-3 sm:gap-4">
            <Button variant="secondary" size="sm" asChild className="text-sm">
              <Link to="/">Voltar à Home</Link>
            </Button>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Tutoriais;
