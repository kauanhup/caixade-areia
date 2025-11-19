// ~/Caixade-Areia/auxs/ComparaImagens.cpp
// Programa que compara duas imagens e retorna o percentual de similaridade

#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <iostream>
#include <string>

using namespace std;
using namespace cv;

int main(int argc, char** argv) {
    // Validar argumentos
    if (argc < 3) {
        cerr << "Erro: Use ./ComparaImagens <imagem_original> <imagem_capturada>" << endl;
        return 1;
    }
    
    string o = argv[1];
    string d = argv[2];
    
    Mat origin = imread(o, 1);
    Mat destino = imread(d, 1);
    
    if (!origin.data) {
        cerr << "Erro: Não foi possível carregar imagem original: " << o << endl;
        return 1;
    }
    
    if (!destino.data) {
        cerr << "Erro: Não foi possível carregar imagem capturada: " << d << endl;
        return 1;
    }
    
    // Verificar se as imagens têm o mesmo tamanho
    if (origin.size() != destino.size()) {
        cerr << "Aviso: Redimensionando imagens para o mesmo tamanho" << endl;
        resize(destino, destino, origin.size());
    }
    
    Mat dstMedianOrigin;
    Mat dstMedianDestino;
    Mat result;
    
    // Aplicar filtros de mediana
    medianBlur(origin, dstMedianOrigin, 41);
    medianBlur(destino, dstMedianDestino, 41);
    
    // Subtrair imagens (detecta diferenças em tons claros e escuros)
    result = (dstMedianOrigin - dstMedianDestino) + (dstMedianDestino - dstMedianOrigin);
    
    // Corrigir contraste/brilho
    result = result + Scalar(-50, -50, -50);
    
    // Erosão para reduzir ruído
    Mat element = getStructuringElement(MORPH_RECT, Size(4,4), Point(-1,-1));
    erode(result, result, element, Point(-1,-1), 2);
    
    medianBlur(result, result, 5);
    
    // Criar imagem de saída com diferenças destacadas
    Mat newImage = Mat::zeros(result.size(), result.type());
    long total = result.rows * result.cols;
    double diferente = 0;
    
    for (int y = 0; y < result.rows; y++) {
        for (int x = 0; x < result.cols; x++) {
            if ((result.at<Vec3b>(y, x)[0] != 0) || 
                (result.at<Vec3b>(y, x)[1] != 0) || 
                (result.at<Vec3b>(y, x)[2] != 0)) {
                
                // Amplificar diferenças
                result.at<Vec3b>(y, x)[0] = saturate_cast<uchar>(2.2 * result.at<Vec3b>(y, x)[0] + 50);
                result.at<Vec3b>(y, x)[1] = saturate_cast<uchar>(2.2 * result.at<Vec3b>(y, x)[1] + 50);
                result.at<Vec3b>(y, x)[2] = saturate_cast<uchar>(2.2 * result.at<Vec3b>(y, x)[2] + 50);
                
                // Marcar diferença em roxo
                newImage.at<Vec3b>(y, x)[0] = 151; // B
                newImage.at<Vec3b>(y, x)[1] = 50;  // G
                newImage.at<Vec3b>(y, x)[2] = 170; // R
                
                diferente++;
            } else {
                // Manter pixel original
                newImage.at<Vec3b>(y, x)[0] = destino.at<Vec3b>(y, x)[0];
                newImage.at<Vec3b>(y, x)[1] = destino.at<Vec3b>(y, x)[1];
                newImage.at<Vec3b>(y, x)[2] = destino.at<Vec3b>(y, x)[2];
            }
        }
    }
    
    // Salvar imagem de diferença
    string outputPath = "../resources/comparacoes/diferenca.png";
    bool saved = imwrite(outputPath, newImage);
    
    if (!saved) {
        cerr << "Aviso: Não foi possível salvar imagem de diferença em " << outputPath << endl;
    }
    
    // Calcular percentual de acerto
    int percentual = 100 - (int)((diferente / total) * 100);
    
    // IMPORTANTE: Imprimir resultado em formato que o C++ pode ler
    cout << "PERCENTUAL:" << percentual << endl;
    
    return 0; // Sempre retornar 0 para sucesso
}
