# fishdataset2 이미지 회전

import os
from PIL import Image


def rotate_images_in_folder(folder_path):
    # 폴더 내의 모든 파일 및 하위 폴더를 순회
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            # 파일 경로 설정
            file_path = os.path.join(root, filename)

            # 파일이 이미지 파일인지 확인 (여기서는 확장자로 판단)
            if filename.lower().endswith(('png', 'jpg', 'jpeg', 'bmp', 'gif')):
                # 이미지 열기
                with Image.open(file_path) as img:
                    # 이미지 회전 및 저장
                    for angle in range(0, 360, 15):
                        # 이미지 회전
                        rotated_img = img.rotate(angle, expand=True)

                        # 새로운 파일 이름 생성
                        new_filename = f"{os.path.splitext(filename)[0]}_rotated_{angle}{os.path.splitext(filename)[1]}"
                        new_file_path = os.path.join(root, new_filename)

                        # 회전된 이미지 저장
                        rotated_img.save(new_file_path)


# FishDataset2 폴더 경로
base_folder_path = '../pythonProject/FishDataset2'

# test, train, val 폴더 각각에 대해 이미지 회전 수행
for folder_name in ['test', 'train', 'val']:
    folder_path = os.path.join(base_folder_path, folder_name)
    rotate_images_in_folder(folder_path)
