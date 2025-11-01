import { Navigation } from "@/components/Navigation";
import { Hero } from "@/components/Hero";
import { Section } from "@/components/Section";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Github, Users, Droplet, Mountain } from "lucide-react";
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious } from "@/components/ui/carousel";

// Assets - Logos
import logoRangelTorres from "@/assets/logo-rangel-torres-new.png";
import logoSeducMT from "@/assets/logo-seduc-mt.png";
import logoDRECaceres from "@/assets/logo-dre-caceres.png";

// Assets - Enchentes
import enchenteAereo from "@/assets/enchente-rio-branco-aereo.png";
import jornalNacional from "@/assets/jornal-nacional-rio-branco.png";
import enchenteRua from "@/assets/enchente-rio-branco-rua.jpg";

// Assets - Medições
import medicaoRioFoto2 from "@/assets/medicao-rio-foto-2.jpg";
import medicaoRioFoto3 from "@/assets/medicao-rio-foto-3.jpg";
import medicaoRioFoto4 from "@/assets/medicao-rio-foto-4.jpg";
import medicaoRioFoto6 from "@/assets/medicao-rio-foto-6.jpg";
import medicaoRioFoto7 from "@/assets/medicao-rio-foto-7.jpg";
import medicaoRioFoto8 from "@/assets/medicao-rio-foto-8.jpg";

// Assets - Construção
import construcaoFoto2 from "@/assets/construcao-foto-2.jpeg";
import construcaoFoto5 from "@/assets/construcao-foto-5.jpeg";
import construcaoFoto6 from "@/assets/construcao-foto-6.jpeg";

// Assets - Dia da Família
import diaFamilia1 from "@/assets/dia-familia-1.jpeg";
import diaFamilia2 from "@/assets/dia-familia-2.jpeg";
import diaFamilia3 from "@/assets/dia-familia-3.jpeg";
import diaFamilia4 from "@/assets/dia-familia-4.jpeg";
import diaFamilia5 from "@/assets/dia-familia-5.jpeg";
import diaFamilia6 from "@/assets/dia-familia-6.jpeg";
import diaFamilia7 from "@/assets/dia-familia-7.jpeg";
import diaFamilia8 from "@/assets/dia-familia-8.jpeg";
import diaFamilia9 from "@/assets/dia-familia-9.jpeg";
import diaFamilia10 from "@/assets/dia-familia-10.jpeg";
import apresentacaoComunidade1 from "@/assets/apresentacao-comunidade-1.jpeg";
import apresentacaoComunidade2 from "@/assets/apresentacao-comunidade-2.jpeg";
import construcaoVideo1 from "@/assets/construcao-video-1.mp4";
import construcaoVideo2 from "@/assets/construcao-video-2.mp4";
import construcaoVideo3 from "@/assets/construcao-video-3.mp4";
import construcaoVideo4 from "@/assets/construcao-video-4.mp4";
import construcaoVideo5 from "@/assets/construcao-video-5.mp4";
import construcaoVideo6 from "@/assets/construcao-video-6.mp4";
import construcaoFoto7 from "@/assets/construcao-foto-7.jpeg";
import construcaoFoto8 from "@/assets/construcao-foto-8.jpeg";
import construcaoFoto10 from "@/assets/construcao-foto-10.jpeg";

// Assets - Maquetes
import maqueteConstrucao1 from "@/assets/maquete-construcao-1.jpeg";
import maqueteConstrucao2 from "@/assets/maquete-construcao-2.jpeg";
import maquetePronta1 from "@/assets/maquete-pronta-1.jpg";
import maquetePronta2 from "@/assets/maquete-pronta-2.jpg";
import maquetePronta3 from "@/assets/maquete-pronta-3.jpg";

// Assets - Inclusão
import criancasInclusao1 from "@/assets/criancas-inclusao-1.jpg";
import criancasInclusao2 from "@/assets/criancas-inclusao-2.jpg";
import tintasNaturaisPreparo from "@/assets/tintas-naturais-preparo.jpg";
import tintasNaturaisResultado from "@/assets/tintas-naturais-resultado.jpg";

// Assets - Software
import softwareSetup1 from "@/assets/software-setup-1.jpg";
import softwareSetup2 from "@/assets/software-setup-2.jpg";
import softwareSetup3 from "@/assets/software-setup-3.jpg";
import softwareSetup4 from "@/assets/software-setup-4.jpg";

// Assets - Equipe
import equipeFinal from "@/assets/equipe-final.jpg";

// Assets - Caixa Funcionando
import caixaFuncionando1 from "@/assets/caixa-funcionando-1.mp4";
import caixaFuncionando2 from "@/assets/caixa-funcionando-2.mp4";

const Index = () => {
  return (
    <div className="min-h-screen">
      <Navigation />
      <Hero />

      <main>

      {/* Context Section */}
      <Section id="context" title="Por que criamos o projeto 'Caixa de Areia'" light>
        <div className="space-y-4 sm:space-y-6">
          <p className="text-base sm:text-lg md:text-xl text-foreground leading-relaxed">
            Em 14 de janeiro 2025, a cidade de Rio Branco (MT) enfrentou uma enchente histórica, causada por intensas chuvas,
            declividade acentuada do relevo elevado índice de desmatamento, sobretudo nas margens do rio. O desastre foi destaque
            no Jornal Nacional e em jornais do Mato Grosso. O evento trouxe grandes prejuízos à população.
          </p>

          <div className="my-4 sm:my-6 rounded-xl overflow-hidden shadow-xl md:hidden">
            <img
              src={enchenteRua}
              alt="Enchente em Rio Branco, MT - ruas alagadas"
              className="w-full h-auto object-cover"
              loading="lazy"
            />
          </div>

          <p className="text-base sm:text-lg md:text-xl text-foreground leading-relaxed">
            A partir desse acontecimento, nossa equipe criou o projeto <strong className="text-primary">Caixa de areia</strong>,
            com o objetivo de simular o escoamento da água precipitada e entender os efeitos do relevo e da ação humana na
            ocorrência de inundações, ajudando na educação ambiental e prevenção de desastres.
          </p>
          <div className="grid sm:grid-cols-2 gap-4 sm:gap-6 mt-6 sm:mt-8">
            <div className="rounded-xl overflow-hidden shadow-xl hover:shadow-2xl transition-shadow">
              <img
                src={jornalNacional}
                alt="Jornal Nacional noticiando a enchente de Rio Branco, MT"
                className="w-full h-auto object-cover"
                loading="lazy"
              />
            </div>
            <div className="rounded-xl overflow-hidden shadow-xl hover:shadow-2xl transition-shadow">
              <img
                src={enchenteAereo}
                alt="Vista aérea da enchente histórica em Rio Branco, MT"
                className="w-full h-auto object-cover"
                loading="lazy"
              />
            </div>
          </div>
        </div>
      </Section>

      {/* Data Collection Section */}
      <Section id="data" title="Medindo o impacto da enchente">
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed">
            A equipe foi ao rio e mediu o fluxo de água durante a enchente, realizando cálculos hidrológicos que
            confirmaram o volume que passou pela ponte. Esses dados ajudaram a validar a simulação no software e
            reforçar a compreensão dos impactos do desmatamento.
          </p>
          <div className="grid md:grid-cols-3 gap-6 mt-10">
            <Card className="bg-card border-2 border-border/50">
              <CardContent className="p-8 text-center">
                <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 mb-6">
                  <Droplet className="h-8 w-8 text-primary" />
                </div>
                <h3 className="font-semibold text-xl mb-3 text-foreground">Medições no Rio</h3>
                <p className="text-sm text-muted-foreground leading-relaxed">Coleta de dados in loco durante a enchente</p>
              </CardContent>
            </Card>
            <Card className="bg-card border-2 border-border/50">
              <CardContent className="p-8 text-center">
                <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 mb-6">
                  <Mountain className="h-8 w-8 text-primary" />
                </div>
                <h3 className="font-semibold text-xl mb-3 text-foreground">Análise de Relevo</h3>
                <p className="text-sm text-muted-foreground leading-relaxed">Estudo do impacto do terreno no fluxo</p>
              </CardContent>
            </Card>
            <Card className="bg-card border-2 border-border/50">
              <CardContent className="p-8 text-center">
                <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/10 mb-6">
                  <Users className="h-8 w-8 text-primary" />
                </div>
                <h3 className="font-semibold text-xl mb-3 text-foreground">Trabalho em Equipe</h3>
                <p className="text-sm text-muted-foreground leading-relaxed">Colaboração multidisciplinar</p>
              </CardContent>
            </Card>
          </div>
          <div className="mt-8 px-4 md:px-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto2}
                      alt="Equipe realizando medições no rio para análise de fluxo de água"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto3}
                      alt="Aluno fazendo anotações das medições hidrológicas do rio"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto4}
                      alt="Estudantes registrando dados de fluxo e volume de água"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto6}
                      alt="Equipe coletando dados sob a ponte durante análise do rio"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto7}
                      alt="Aluno utilizando equipamento para medir velocidade do fluxo de água"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={medicaoRioFoto8}
                      alt="Esquema desenhado com as medições e cálculos hidrológicos realizados"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>
        </div>
      </Section>

      {/* About Section */}
      <Section id="about" title="Tecnologia e aprendizado em ação" light>
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed">
            O projeto <strong className="text-primary">Caixa de Areia — STEAM 2025</strong> adapta um software de
            simulação de relevo e fluxo de água para fins educacionais. Desenvolvido pela equipe da escola, o projeto
            visa demonstrar como a tecnologia pode ajudar no ensino de geografia e ciências da natureza.
          </p>

          <div className="mt-8 px-4 md:px-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={caixaFuncionando1} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={caixaFuncionando2} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>

          <p className="text-lg text-foreground leading-relaxed">
            A partir do software e da maquete interativa, os alunos exploram conceitos de relevo e água de forma
            prática, divertida e inclusiva.
          </p>
        </div>
      </Section>

      {/* Construction Section */}
      <Section id="construction" title="Como construímos a caixa de areia">
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed text-center">
            Confira agora alguns vídeos e fotos do processo de criação da nossa caixa de areia interativa:
          </p>

          <div className="mt-8 px-4 md:px-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo1} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo2} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo3} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo4} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo5} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg bg-muted min-h-[400px] flex items-center justify-center">
                    <video 
                      controls 
                      className="w-full h-auto"
                      preload="metadata"
                    >
                      <source src={construcaoVideo6} type="video/mp4" />
                      Seu navegador não suporta vídeos.
                    </video>
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={construcaoFoto8}
                      alt="Processo de construção da estrutura da caixa de areia"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={construcaoFoto10}
                      alt="Estrutura completa da caixa de areia com projetor e sensor Kinect instalados"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>

          <p className="text-lg text-foreground leading-relaxed mt-8">
            O projeto envolveu a criação de uma maquete física. A equipe participou de todo o processo: montagem da estrutura, modelagem e etc.
          </p>

          <div className="mt-8 px-4 md:px-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={maqueteConstrucao1}
                      alt="Alunas trabalhando na finalização da maquete com detalhes de vegetação"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={maqueteConstrucao2}
                      alt="Aluna pintando e decorando o relevo da maquete"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>

          <div className="mt-12 px-4 md:px-8">
            <h3 className="text-xl font-semibold mb-6 text-center">Resultado Final</h3>
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={maquetePronta3}
                      alt="Maquete completa com relevo detalhado e vegetação"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={maquetePronta1}
                      alt="Maquete finalizada mostrando relevo com vegetação decorativa"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={maquetePronta2}
                      alt="Vista da estrutura base da maquete em diferentes camadas"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>
        </div>
      </Section>

      {/* Inclusion Section */}
      <Section id="inclusion" title="Aprendizado para todos" light>
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed">
            A inclusão é parte essencial do projeto. Alunos com deficiência participaram das atividades, ajudaram
            na criação e exploraram o aprendizado de forma acessível e divertida.
          </p>
          <div className="grid md:grid-cols-2 gap-4 mt-8">
            <div className="rounded-lg overflow-hidden shadow-lg">
              <img
                src={criancasInclusao1}
                alt="Crianças com deficiência participando e interagindo com a caixa de areia"
                className="w-full h-auto object-cover"
                loading="lazy"
              />
            </div>
            <div className="rounded-lg overflow-hidden shadow-lg">
              <img
                src={criancasInclusao2}
                alt="Atividades inclusivas com alunos especiais explorando o projeto"
                className="w-full h-auto object-cover"
                loading="lazy"
              />
            </div>
          </div>
          <p className="text-lg text-foreground leading-relaxed mt-8">
            Criamos tintas naturais com solos de diferentes cores para permitir interação prática e criativa com a
            caixa de areia, estimulando a criatividade e o aprendizado sensorial.
          </p>

          <div className="max-w-3xl mx-auto mt-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={tintasNaturaisPreparo}
                      alt="Preparo de tintas naturais com solos de diferentes cores"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={tintasNaturaisResultado}
                      alt="Resultado das tintas naturais aplicadas mostrando diferentes cores"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>
        </div>
      </Section>

      {/* Presentation Section */}
      <Section id="presentation" title="Apresentando o projeto à comunidade">
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed">
            No <strong className="text-primary">Dia da Família</strong>, o projeto foi apresentado à comunidade,
            com a presença de vereadores e convidados especiais. Um momento de orgulho e aprendizado
            coletivo.
          </p>
          
          <div className="mt-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia1} 
                      alt="Apresentação do projeto no Dia da Família - Banner sobre barraginhas"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia2} 
                      alt="Crianças interagindo com a caixa de areia no Dia da Família"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia3} 
                      alt="Demonstração da caixa de areia para crianças e famílias"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia4} 
                      alt="Comunidade interagindo com o projeto educativo"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia5} 
                      alt="Apresentação e explicação do projeto para o público"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia6} 
                      alt="Famílias e crianças aprendendo sobre o projeto"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia7} 
                      alt="Crianças explorando a maquete interativa"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia8} 
                      alt="Estudantes explicando o conceito de curva de nível"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia9} 
                      alt="Professor apresentando o projeto com banner educativo"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={diaFamilia10} 
                      alt="Professor Adriano com a maquete durante apresentação no Dia da Família"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>

          <p className="text-lg text-foreground leading-relaxed">
            Recebemos também o convite para apresentar o projeto na <strong className="text-primary">Câmara dos Vereadores de Rio Branco</strong> na quarta-feira, dia 29 de outubro,
            uma honra para toda a equipe e mais uma oportunidade de compartilhar nosso trabalho com a comunidade. Na apresentação, contamos com a presença de 2 vereadores da cidade vizinha <strong className="text-primary">Salto do Céu</strong>, pois as enchentes afetaram nossas duas cidades.
          </p>
          
          <div className="mt-8 rounded-lg overflow-hidden shadow-lg aspect-video">
            <iframe
              width="100%"
              height="100%"
              src="https://www.youtube.com/embed/_bc_7kpPVEk"
              title="Apresentação do Projeto Caixa de Areia na Câmara dos Vereadores"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
              className="w-full h-full"
            ></iframe>
          </div>

          <div className="mt-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={apresentacaoComunidade1} 
                      alt="Apresentação na Câmara dos Vereadores com equipe e autoridades"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="relative overflow-hidden rounded-lg bg-muted flex items-center justify-center min-h-[400px]">
                    <img 
                      src={apresentacaoComunidade2} 
                      alt="Demonstração do projeto com maquete funcionando na Câmara"
                      className="w-full h-auto object-contain"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>
        </div>
      </Section>

      {/* Software Section */}
      <Section id="software" title="Acesse o software e explore o projeto" light>
        <div className="space-y-6">
          <p className="text-lg text-foreground leading-relaxed">
            O software modificado simula o fluxo de água e relevo. Fizemos atualizações importantes no código e correções de bugs.
            O repositório completo no GitHub será disponibilizado dia <strong className="text-primary">15 de novembro</strong> com todas as instruções de instalação.
          </p>

          <Card className="bg-card border-2 border-primary/20">
            <CardContent className="p-8 text-center">
              <h3 className="text-xl font-semibold mb-4 flex items-center justify-center gap-2">
                <Github className="h-6 w-6 text-primary" />
                Repositório do Projeto
              </h3>
              <p className="text-muted-foreground mb-6">
                Acesse o código-fonte completo do projeto no GitHub
              </p>
              <Button size="lg" asChild className="flex items-center gap-2 mx-auto">
                <a 
                  href="https://github.com/kauanhup/caixade-areia" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="flex items-center gap-2"
                >
                  <Github className="h-5 w-5" />
                  Acessar Repositório
                </a>
              </Button>
            </CardContent>
          </Card>

          <div className="bg-muted rounded-lg p-6 mt-8">
            <h4 className="font-semibold mb-3 text-lg">Créditos do Software</h4>
            <p className="text-sm text-muted-foreground leading-relaxed">
              O software Caixa de Areia usado neste projeto é baseado no{" "}
              <a
                href="https://caixae-agua.blogspot.com/"
                target="_blank"
                rel="noopener noreferrer"
                className="text-primary hover:underline font-medium"
              >
                Caixa e Água
              </a>
              , que é uma adaptação do{" "}
              <a
                href="https://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/"
                target="_blank"
                rel="noopener noreferrer"
                className="text-primary hover:underline font-medium"
              >
                AR Sandbox
              </a>
              {" "}(R-Sandbox) da UC Davis, e foi modificado pela Escola Rangel Torres — STEAM MT 2025,
              mantendo os créditos das versões anteriores.
            </p>
          </div>

          <div className="mt-8 px-4 md:px-8">
            <Carousel className="w-full">
              <CarouselContent>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={softwareSetup1}
                      alt="Setup do software Caixa de Areia - terminal de configuração"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={softwareSetup2}
                      alt="Setup do software Caixa de Areia - estrutura montada com projeção"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={softwareSetup3}
                      alt="Setup do software Caixa de Areia - visão geral do sistema"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
                <CarouselItem>
                  <div className="rounded-lg overflow-hidden shadow-lg">
                    <img
                      src={softwareSetup4}
                      alt="Setup do software Caixa de Areia - caixa vazia pronta para uso"
                      className="w-full h-auto object-cover"
                      loading="lazy"
                    />
                  </div>
                </CarouselItem>
              </CarouselContent>
              <CarouselPrevious className="left-2" />
              <CarouselNext className="right-2" />
            </Carousel>
          </div>
        </div>
      </Section>

      {/* Team Section */}
      <Section id="team" title="Equipe e agradecimentos">
        <div className="space-y-6">
          <Card className="bg-card">
            <CardContent className="p-8">
              <h3 className="text-xl font-semibold mb-4 text-primary">Equipe do Projeto</h3>
              <div className="space-y-2 text-foreground">
                <p><strong>Alunos:</strong> Helena, Isadora, João Luiz e Kauan</p>
                <p><strong>Professor Orientador:</strong> Prof. Dr. Josiel Dorriguette</p>
                <p><strong>Escola:</strong> Rangel Torres</p>
                <p><strong>Ano:</strong> 2025</p>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-muted border-none">
            <CardContent className="p-8">
              <h3 className="text-xl font-semibold mb-4">Agradecimentos</h3>
              <p className="text-muted-foreground mb-4">
                Agradecemos a todos que tornaram este projeto possível — ao professor orientador, aos alunos participantes e a toda a comunidade escolar da Escola Rangel Torres, e à STEAM MT, pela oportunidade de apresentar e compartilhar este trabalho.
              </p>
              <div className="flex justify-center mt-8">
                <img
                  src={logoRangelTorres}
                  alt="Logo da Escola Rangel Torres"
                  className="h-32 w-auto object-contain"
                  loading="lazy"
                />
              </div>
            </CardContent>
          </Card>

          <div className="bg-secondary rounded-lg p-6 text-center">
            <p className="text-sm text-muted-foreground">
              <strong>Software original:</strong> AR Sandbox<br />
              <strong>Modificado por:</strong> Caixa e Água<br />
              <strong>Versão STEAM MT 2025:</strong> Equipe Escola Rangel Torres
            </p>
          </div>

          <div className="rounded-lg overflow-hidden shadow-lg mt-12">
            <img
              src={equipeFinal}
              alt="Equipe completa do projeto Caixa de Areia com o professor orientador"
              className="w-full h-auto object-cover"
              loading="lazy"
            />
          </div>
        </div>
      </Section>

      </main>

      {/* Footer */}
      <footer className="relative bg-gradient-to-b from-accent to-accent/90 text-accent-foreground py-12 sm:py-16 md:py-20 border-t border-accent-foreground/10" role="contentinfo">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="max-w-4xl mx-auto text-center space-y-8">
            <div className="space-y-3">
              <h3 className="text-2xl sm:text-3xl md:text-4xl font-bold">Caixa de Areia</h3>
              <p className="text-accent-foreground/70 text-base sm:text-lg font-light">
                STEAM MT 2025 - Tecnologia, inclusão e aprendizado
              </p>
            </div>

            <div className="w-20 h-1 bg-gradient-to-r from-accent-foreground/0 via-accent-foreground/30 to-accent-foreground/0 mx-auto"></div>

            <div className="flex flex-wrap justify-center items-center gap-8 sm:gap-10 md:gap-12">
              <img
                src={logoSeducMT}
                alt="Logo SEDUC MT"
                className="h-14 sm:h-16 md:h-20 w-auto object-contain opacity-90 hover:opacity-100 transition-opacity"
                loading="lazy"
              />
              <img
                src={logoDRECaceres}
                alt="Logo DRE Cáceres"
                className="h-14 sm:h-16 md:h-20 w-auto object-contain opacity-90 hover:opacity-100 transition-opacity"
                loading="lazy"
              />
            </div>

            <div className="flex justify-center gap-4">
              <Button variant="secondary" size="lg" asChild className="shadow-lg hover:shadow-xl transition-all">
                <a href="#home">Voltar ao Início</a>
              </Button>
            </div>

            <div className="pt-6 border-t border-accent-foreground/10">
              <p className="text-xs sm:text-sm text-accent-foreground/50">
                © 2025 Escola Rangel Torres - Todos os direitos reservados
              </p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
