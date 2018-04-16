import requests, os, sys
TARGET_PATH = ''


def download(image_url, _id):
    target_filename = _id + '.jpg'
    target_image_path = os.path.join(TARGET_PATH, target_filename)
    print('Downloading to: ', target_image_path)

    if os.path.exists(target_image_path):
        return

    r = requests.get(image_url)
    print('status', r.status_code)
    assert r.status_code == 200

    # Note see: https://stackoverflow.com/questions/13137817/how-to-download-image-using-requests
    with open(target_image_path, 'wb') as f_out:
        r.raw.decode_content = True
        for chunk in r.iter_content(1024):
            f_out.write(chunk)


def download_all(filename):
    with open(filename, 'r') as f:
        l = next(f)

        for line in f:
            split_line = line.split(';')
            image_url = split_line[9][:-8] + '2000.jpg'
            print(image_url)
            _id = split_line[2]

            download(image_url, _id)

if __name__ == '__main__':
    print('usage print downloader.py <TARGET DIRECTORY> <CSV FILE>')
    assert len(sys.argv[1:]) == 2
    TARGET_PATH = sys.argv[1]
    download_all(sys.argv[2])

