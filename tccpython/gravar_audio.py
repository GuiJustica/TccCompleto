import sounddevice as sd
from scipy.io.wavfile import write

# Configurações
fs = 16000  # Taxa de amostragem (em Hz)
duracao = 5  # Tempo de gravação (em segundos)

print("Gravando áudio...")

# Captura o áudio
audio = sd.rec(int(duracao * fs), samplerate=fs, channels=1, dtype='int16')
sd.wait()  # Espera o término da gravação

# Salva como WAV
arquivo_saida = "audio_capturado.wav"
write(arquivo_saida, fs, audio)

print(f"Gravação finalizada. Áudio salvo como {arquivo_saida}")
