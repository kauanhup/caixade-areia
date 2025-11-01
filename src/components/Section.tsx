import { ReactNode } from "react";
import { cn } from "@/lib/utils";

interface SectionProps {
  id: string;
  title: string;
  children: ReactNode;
  className?: string;
  light?: boolean;
}

export const Section = ({ id, title, children, className, light = false }: SectionProps) => {
  return (
    <section
      id={id}
      className={cn(
        "py-16 sm:py-20 md:py-24 lg:py-32 scroll-mt-20",
        light ? "bg-secondary/50" : "bg-background",
        className
      )}
      aria-labelledby={`${id}-title`}
    >
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <header className="text-center mb-12 sm:mb-16 md:mb-20 space-y-4">
          <h2 id={`${id}-title`} className="text-3xl sm:text-4xl md:text-5xl lg:text-6xl font-bold text-primary leading-tight tracking-tight animate-fade-in">
            {title}
          </h2>
          <div className="w-20 h-1 bg-gradient-to-r from-primary/0 via-primary to-primary/0 mx-auto" aria-hidden="true"></div>
        </header>
        <div className="max-w-6xl mx-auto">{children}</div>
      </div>
    </section>
  );
};
