import tensorflow as tf

# # h5 -> pb 변환
# # H5 파일에서 모델 로드
# cnn_model = tf.keras.models.load_model('fish_classification_model_final.h5')
#
# # SavedModel 형식으로 모델 저장
# tf.saved_model.save(cnn_model, 'fish_classification_model_final_saved_model')
#
# # SavedModel을 pb 파일로 내보내기
# converter = tf.compat.v1.lite.TFLiteConverter.from_saved_model('fish_classification_model_final_saved_model')
# tflite_model = converter.convert()
#
# # pb 파일로 저장
# with open('fish_classification_model_final.pb', 'wb') as f:
#     f.write(tflite_model)


# pb -> tflite 변환
# 'pb' 파일의 경로
saved_model_dir = './fish_classification_model_final_saved_model'
converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS,
                                       tf.lite.OpsSet.SELECT_TF_OPS]
tflite_model = converter.convert()
open('./fish_classification_model_final.tflite', 'wb').write(tflite_model)
