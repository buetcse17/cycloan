from cycloan.settings import CUSTOMER_DOC_DIR, CUSTOMER_PHOTO_DIR


# photo filename = ID + . + photo_ext
def save_customer_photo(photo, customer_id, contact):
    photo_ext = photo.name.split('.')[-1]
    photo_path = "".join([CUSTOMER_PHOTO_DIR, str(customer_id), '_', contact , '.', photo_ext])
    photo_static_path = "".join(["static/", photo_path ])
    photo_file = open(photo_static_path, 'wb')

    for chunk in photo.chunks():
        photo_file.write(chunk)
    photo_file.close()

    # save it in database
    return photo_path


# doc filename = ID + . + doc_ext
def save_customer_doc(document, customer_id, contact):
    doc_ext = document.name.split('.')[-1]
    doc_path = "".join([CUSTOMER_DOC_DIR, str(customer_id), '_', contact, '.', doc_ext])
    doc_static_path = "".join(["static/", doc_path ])
    doc_file = open(doc_static_path, 'wb')

    for chunk in document.chunks():
        doc_file.write(chunk)
    doc_file.close()

    # save it in database
    return doc_path
