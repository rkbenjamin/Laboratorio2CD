clc; 
clear; 
close all;
frecuencia_base = 1;
ancho_banda = 2 * frecuencia_base;

roll_off_factors=[0, 0.25, 0.75, 1];  
colores=['b', 'r', 'g', 'm'];

tiempo=linspace(0, 10/frecuencia_base, 1000);

frecuencia=linspace(-2*ancho_banda, 2*ancho_banda, 1000);

figure('Name', 'Respuesta al Impulso', 'Position', [100 100 800 400]);
hold on;

for i=1:length(roll_off_factors)
    alpha=roll_off_factors(i);
    f_delta=alpha*frecuencia_base;
    
    termino_sinc=sin(2*pi*frecuencia_base*tiempo) ./ (2*pi*frecuencia_base*tiempo);
    termino_sinc(isnan(termino_sinc))=1;
    
    denominador=1-(4*f_delta*tiempo).^2;
    
    respuesta_impulso=2*frecuencia_base*termino_sinc .* ...
                       (cos(2*pi*f_delta*tiempo) ./ denominador);
    
    respuesta_impulso(denominador==0)=0;
    
    plot(tiempo, respuesta_impulso, colores(i), ...
         'LineWidth', 1.5, ...
         'DisplayName', ['\alpha = ' num2str(alpha)]);
end

title('Respuesta al Impulso del Filtro de Coseno Alzado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Location', 'best');
grid on;
hold off;

figure('Name', 'Respuesta en Frecuencia', 'Position', [100 100 800 400]);
hold on;

for i=1:length(roll_off_factors)
    alpha=roll_off_factors(i);
    f_delta=alpha*frecuencia_base;
    f_transicion=frecuencia_base-f_delta;
    
    respuesta_frecuencia=zeros(size(frecuencia));
    
    for k=1:length(frecuencia)
        f_abs=abs(frecuencia(k));
        
        if f_abs<f_transicion
            respuesta_frecuencia(k)=1;
            
        elseif (f_abs >= f_transicion) && (f_abs < ancho_banda)
            respuesta_frecuencia(k)=0.5*(1+cos(pi*(f_abs-f_transicion)/(4.5*f_delta)));
            
        else
            respuesta_frecuencia(k)=0;
        end
    end
    
    plot(frecuencia, respuesta_frecuencia, colores(i), ...
         'LineWidth', 1.5, ...
         'DisplayName', ['\alpha = ' num2str(alpha)]);
end

title('Respuesta en Frecuencia del Filtro de Coseno Alzado');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
legend('Location', 'best');
grid on;
hold off;