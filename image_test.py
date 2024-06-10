import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing import image
import matplotlib.pyplot as plt

# 모델 로드
model = tf.keras.models.load_model('fish_classification_model_real_final.h5')

# 클래스 인덱스 설정
class_indices = {
    'Bangus': 0,
    'Big Head Carp': 1,
    'Black Sea Sprat': 2,
    'Black Spotted Barb': 3,
    'Catfish': 4,
    'Climbing Perch': 5,
    'Fourfinger Threadfin': 6,
    'Freshwater Eel': 7,
    'Gilt-Head Bream': 8,
    'Glass Perchlet': 9,
    'Goby': 10,
    'Gold Fish': 11,
    'Gourami': 12,
    'Grass Carp': 13,
    'Green Spotted Puffer': 14,
    'Hourse Mackerel': 15,
    'Indian Carp': 16,
    'Indo-Pacific Tarpon': 17,
    'Jaguar Gapote': 18,
    'Janitor Fish': 19,
    'Knifefish': 20,
    'Long-Snouted Pipefish': 21,
    'Mosquito Fish': 22,
    'Mudfish': 23,
    'Mullet': 24,
    'Pangasius': 25,
    'Perch': 26,
    'Red Mullet': 27,
    'Red Sea Bream': 28,
    'Scat Fish': 29,
    'Sea Bass': 30,
    'Shrimp': 31,
    'Silver Barb': 32,
    'Silver Carp': 33,
    'Silver Perch': 34,
    'Snakehead': 35,
    'Striped Red Mullet': 36,
    'Tenpounder': 37,
    'Tilapia': 38,
    'Trout': 39
}


# 클래스 인덱스를 라벨로 변환
class_labels = {v: k for k, v in class_indices.items()}

# 이미지 전처리 함수
def preprocess_image(img_path, target_size=(224, 224)):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = tf.keras.applications.mobilenet_v2.preprocess_input(img_array)
    return img_array

# 이미지 예측 함수
def predict_fish_species(img_path):
    img = preprocess_image(img_path)
    predictions = model.predict(img)
    predicted_index = np.argmax(predictions, axis=1)[0]
    predicted_label = class_labels[predicted_index]
    confidence = np.max(predictions) * 100
    return predicted_index, predicted_label, confidence

# 이미지 파일 경로
img_path = 'red mullet1.jpg'

# 예측 수행
predicted_index, predicted_label, confidence = predict_fish_species(img_path)

# 결과 출력
print(f'예측 인덱스: {predicted_index}')
print(f'예측 라벨: {predicted_label}')
print(f'신뢰도: {confidence:.2f}%')

# 예측 결과 시각화
def display_image(img_path, label, confidence):
    img = image.load_img(img_path)
    plt.imshow(img)
    plt.title(f'{label} ({confidence:.2f}%)')
    plt.axis('off')
    plt.show()

display_image(img_path, predicted_label, confidence)
