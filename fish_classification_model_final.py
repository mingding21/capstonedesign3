import os
import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt
from pathlib import Path
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, classification_report

# 설정
pd.set_option('display.max_columns', None)

# 메모리 부족 오류 방지
gpu_devices = tf.config.experimental.list_physical_devices('GPU')
for device in gpu_devices:
    tf.config.experimental.set_memory_growth(device, True)

# 기존 데이터셋 불러오기
direc = Path('../pythonProject/FishDataset/Fish_Dataset')
filepaths = list(direc.glob(r'**/*.png'))
Labels = list(map(lambda x: os.path.split(os.path.split(x)[0])[1], filepaths))

filepaths = pd.Series(filepaths, name='FilePaths').astype(str)
Labels = pd.Series(Labels, name='Labels').astype(str)
img_df = pd.merge(filepaths, Labels, right_index=True, left_index=True)
img_df = img_df[img_df['Labels'].apply(lambda x: x[-2:] != 'GT')]

# 새로운 데이터셋 불러오기
new_direc = Path('../pythonProject/FishDataset2')
new_filepaths = list(new_direc.glob(r'**/*.jpg'))
new_labels = list(map(lambda x: os.path.split(os.path.split(x)[0])[1], new_filepaths))

new_filepaths = pd.Series(new_filepaths, name='FilePaths').astype(str)
new_labels = pd.Series(new_labels, name='Labels').astype(str)
new_img_df = pd.merge(new_filepaths, new_labels, right_index=True, left_index=True)

# 새로운 데이터셋 라벨 확인
new_labels_unique = new_img_df['Labels'].unique()
print(f'새 데이터셋의 클래스 수: {len(new_labels_unique)}')
print(f'새 데이터셋의 클래스 라벨: {new_labels_unique}')

# 기존 데이터셋과 새로운 데이터셋 통합
img_df = pd.concat([img_df, new_img_df], ignore_index=True)

# 병합된 데이터셋의 클래스 라벨 확인
all_labels_unique = img_df['Labels'].unique()
print(f'병합된 데이터셋의 클래스 수: {len(all_labels_unique)}')
print(f'병합된 데이터셋의 클래스 라벨: {all_labels_unique}')

# 데이터 섞기
img_df = img_df.sample(frac=1).reset_index(drop=True)

# 훈련 데이터, 테스트 데이터, 검증 데이터로 나누기
train_ratio = 0.75
validation_ratio = 0.10
test_ratio = 0.15

x_train, x_test = train_test_split(img_df, test_size=1 - train_ratio)
x_val, x_test = train_test_split(x_test, test_size=test_ratio / (test_ratio + validation_ratio))

print(f'훈련 데이터 세트 : {x_train.shape}')
print(f'테스트 데이터 세트 : {x_test.shape}')
print(f'검증 데이터 세트 : {x_val.shape}')

# 이미지 전처리 및 데이터 증강
img_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.mobilenet_v2.preprocess_input,
    validation_split=0.15,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

# 입력 이미지 크기 지정
img_size = (224, 224)
batch_size = 32

# 클래스 목록 생성
classes_list = img_df['Labels'].unique().tolist()

# 훈련 데이터 및 검증 데이터 생성
train_data = img_datagen.flow_from_dataframe(dataframe=x_train, x_col='FilePaths', y_col='Labels',
                                             target_size=img_size, color_mode='rgb', class_mode='categorical',
                                             batch_size=batch_size, seed=42, subset='training', classes=classes_list)

val_data = img_datagen.flow_from_dataframe(dataframe=x_train, x_col='FilePaths', y_col='Labels',
                                           target_size=img_size, color_mode='rgb', class_mode='categorical',
                                           batch_size=batch_size, seed=42, subset='validation', classes=classes_list)

# 테스트 데이터 세트 생성
test_data = img_datagen.flow_from_dataframe(dataframe=x_test, x_col='FilePaths', y_col='Labels',
                                            target_size=img_size, color_mode='rgb', class_mode='categorical',
                                            batch_size=batch_size, seed=42, classes=classes_list)

# 훈련 데이터의 클래스 라벨 인덱스를 가져옴
class_labels = train_data.class_indices
num_classes = len(class_labels)

# 클래스 라벨과 해당 인덱스를 출력
for label, index in class_labels.items():
    print(f'Index: {index}, Label: {label}')

# CNN 모델 생성
base_model = tf.keras.applications.MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))

x = base_model.output
x = tf.keras.layers.GlobalAveragePooling2D()(x)
x = tf.keras.layers.Dense(512, activation='relu')(x)
x = tf.keras.layers.Dropout(0.5)(x)
predictions = tf.keras.layers.Dense(num_classes, activation='softmax')(x)

model = tf.keras.models.Model(inputs=base_model.input, outputs=predictions)

# 일부 레이어들을 재학습하도록 설정
for layer in base_model.layers[:-20]:
    layer.trainable = False
for layer in base_model.layers[-20:]:
    layer.trainable = True

# 모델 컴파일
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# 모델 훈련
history = model.fit(
    train_data,
    steps_per_epoch=train_data.samples // train_data.batch_size,
    epochs=20,
    validation_data=val_data,
    validation_steps=val_data.samples // val_data.batch_size
)

# 테스트 데이터로 모델 평가
test_loss, test_accuracy = model.evaluate(test_data)
print('테스트 정확도는:', test_accuracy * 100, '%')

# 모델 저장
model.save('fish_classification_model_final.h5')
print('모델이 fish_classification_model_final.h5 파일로 저장되었습니다.')

# Training Accuracy와 Validation Accuracy 비교 그래프
plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.title('Training and Validation Accuracy')
plt.legend()
plt.show()

# Training Loss와 Validation Loss 비교 그래프
plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.title('Training and Validation Loss')
plt.legend()
plt.show()