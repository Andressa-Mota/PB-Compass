from robot.api.deco import keyword
from pymongo import MongoClient


Client = MongoClient('mongodb+srv://andressa:dhee.14@mark85.agzdykw.mongodb.net/?retryWrites=true&w=majority&appName=mark85')
db = Client['test']

@keyword ('remover usuario do banco de dados')
def remove_user(email):
        users=db.users
        users.delete_many({'email':email})
        print('removendo o email '+ email)
@keyword ('inserir usuario no banco de dados')
def insert_user(user):
        # doc = {
        #         'name': name,
        #         'email': email,
        #         'password': password
        # }
        users = db['users']
        users.insert_one(user)
        print(user)
       