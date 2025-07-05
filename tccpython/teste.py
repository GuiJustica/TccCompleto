import sounddevice as sd
import numpy as np
import tensorflow as tf
import tensorflow_hub as hub
import librosa

import pandas as pd

# Parâmetros de captura
DURATION = 1.0  # segundos
SAMPLING_RATE = 16000  # Hz

print("Gravando...")
audio = sd.rec(int(DURATION * SAMPLING_RATE), samplerate=SAMPLING_RATE, channels=1, dtype='float32')
sd.wait()
print("Gravação concluída!")

# Remove dimensão extra e normaliza
audio = np.squeeze(audio)

# Carrega YAMNet

yamnet_model = hub.load('https://tfhub.dev/google/yamnet/1')

# Lê o arquivo de classes
class_map_path = yamnet_model.class_map_path().numpy().decode('utf-8')
classes = pd.read_csv(class_map_path)['display_name'].tolist()

print(len(classes))
print(classes)
class_map_path = tf.keras.utils.get_file(
    'yamnet_class_map.csv',
    'https://raw.githubusercontent.com/tensorflow/models/master/research/audioset/yamnet/yamnet_class_map.csv'
)

class_names = [line.strip().split(',')[2] for line in open(class_map_path).readlines()[1:]]

# Rodar predição
scores, embeddings, spectrogram = yamnet_model(audio)
mean_scores = tf.reduce_mean(scores, axis=0)
top_class = tf.argmax(mean_scores)
print(f"Som detectado: {class_names[top_class]}")


