import { useState, useEffect, useRef } from "react";
import { cn } from "@/lib/utils";

interface LazyVideoProps {
  src: string;
  className?: string;
  preload?: "none" | "metadata" | "auto";
}

export const LazyVideo = ({ src, className, preload = "none" }: LazyVideoProps) => {
  const [isInView, setIsInView] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsInView(true);
            observer.disconnect();
          }
        });
      },
      {
        rootMargin: "100px",
      }
    );

    if (containerRef.current) {
      observer.observe(containerRef.current);
    }

    return () => {
      observer.disconnect();
    };
  }, []);

  return (
    <div ref={containerRef} className={cn("relative overflow-hidden bg-muted min-h-[400px] flex items-center justify-center", className)}>
      {isInView ? (
        <video 
          controls 
          className="w-full h-auto"
          preload={preload}
        >
          <source src={src} type="video/mp4" />
          Seu navegador não suporta vídeos.
        </video>
      ) : (
        <div className="absolute inset-0 bg-muted animate-pulse flex items-center justify-center">
          <span className="text-muted-foreground">Carregando vídeo...</span>
        </div>
      )}
    </div>
  );
};
