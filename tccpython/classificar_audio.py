import tensorflow as tf
import tensorflow_hub as hub
import numpy as np
import librosa

# Carrega modelo YAMNet do TensorFlow Hub
yamnet_model_handle = 'https://tfhub.dev/google/yamnet/1'
yamnet_model = hub.load(yamnet_model_handle)

# Carrega mapeamento de classes
import urllib.request
class_map_path = tf.keras.utils.get_file(
    'yamnet_class_map.csv',
    'https://raw.githubusercontent.com/tensorflow/models/master/research/audioset/yamnet/yamnet_class_map.csv'
)

import pandas as pd
classes = pd.read_csv(class_map_path)['display_name'].to_list()

# Carrega o áudio capturado
arquivo_audio = 'audio_capturado.wav'
amostra, sr = librosa.load(arquivo_audio, sr=16000)

# Classifica o áudio com YAMNet
scores, embeddings, spectrogram = yamnet_model(amostra)

# Pega o score médio para cada classe
scores_np = scores.numpy()
mean_scores = np.mean(scores_np, axis=0)

# Top 5 classes
top5_i = np.argsort(mean_scores)[::-1][:5]

print("\n🎧 Som detectado - Top 5 categorias:")
for i in top5_i:
    print(f"{classes[i]}: {mean_scores[i]:.3f}")
