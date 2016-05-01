import  time

from flask import Flask, render_template, json, request, redirect, session
from flask.ext.mysql import MySQL
from werkzeug import generate_password_hash, check_password_hash

app = Flask(__name__)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'BucketList'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

# set a secret key for the session
app.secret_key = 'why would I tell you my secret key?'

@app.route("/")
def main():
    return render_template('index.html')

@app.route('/showSignUp')
def showSignUp():
    return render_template('signup.html')

@app.route('/signUp',methods=['POST','GET'])
def signUp():
    # read the posted values from the UI
    _name = request.form['inputName']
    _email = request.form['inputEmail']
    _password = request.form['inputPassword']

    # validate the received values
    if _name and _email and _password:
        conn = mysql.connect()
        cursor = conn.cursor()

        #_password = generate_password_hash(_password) 
        sql_string = 'insert into tbl_user (user_name, user_username, user_password) values("{}","{}","{}")' \
            .format(_name, _email, _password)
        cursor.execute(sql_string)

        data = cursor.fetchall()

        if len(data) is 0:
            conn.commit()
            return json.dumps({
                    'message': 'User created successfully !',
                    'success': True
                })
        else:
            return json.dumps({'error':str(data[0])})  
    else:
        return json.dumps({'error':'Enter the required fields'})     


@app.route('/showSignIn')
def showSignin():
    return render_template('signin.html')

@app.route('/validateLogin',methods=['POST'])
def validateLogin():
    try:
        _username = request.form['inputEmail']
        _password = request.form['inputPassword']

        con = mysql.connect()
        cursor = con.cursor()
        #_password = generate_password_hash(_password) 
        #cursor.callproc('sp_validateLogin',(_username,))
        cursor.execute("select * from tbl_user where user_username=%s", (_username, ))
        data = cursor.fetchall()
        if len(data) > 0:
            print data, "-----data"
            if data[0][3]==_password:
                session['user'] = data[0][0]
                return redirect('/userHome')
            else:
                return render_template('error.html',error = 'Wrong Email address or Password')
        else:
            return render_template('error.html',error='Wrong Email address or Password')

    except Exception as e:
        return render_template('error.html',error=str(e))
    finally:
        cursor.close()
        con.close()

@app.route('/userHome')
def userHome():
    if session.get('user'):
        return render_template('userHome.html')
    else:
        return render_template('error.html',error = 'Unauthorized Access')

@app.route('/logout')
def logout():
    session.pop('user',None)
    return redirect('/')

@app.route('/showAddWish')
def showAddWish():
    return render_template('addWish.html')

@app.route('/addWish',methods=['POST'])
def addWish():
    try:
        if session.get('user'):
            _title = request.form['inputTitle']
            _description = request.form['inputDescription']
            _user = session.get('user')
 
            conn = mysql.connect()
            cursor = conn.cursor()
            sql_string = '''
                insert into tbl_wish (wish_title, wish_description, wish_user_id, wish_date) 
                values(%s, %s, %s, %s)
                '''
            cursor.execute(sql_string, (_title, _description, _user, time.strftime('%Y-%m-%d %H:%M:%S')))

            data = cursor.fetchall()
 
            if len(data) is 0:
                conn.commit()
                return redirect('/userHome')
            else:
                return render_template('error.html',error = 'An error occurred!')
 
        else:
            return render_template('error.html',error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html',error = str(e))
    finally:
        cursor.close()
        conn.close()

@app.route('/getWish')
def getWish():
    try:
        if session.get('user'):
            _user = session.get('user')
 
            con = mysql.connect()
            cursor = con.cursor()
            cursor.execute('select * from tbl_wish where wish_user_id=%s', (_user,))
            wishes = cursor.fetchall()
 
            wishes_dict = []
            for wish in wishes:
                wish_dict = {
                        'Id': wish[0],
                        'Title': wish[1],
                        'Description': wish[2],
                        'Date': wish[4]}
                wishes_dict.append(wish_dict)
 
            return json.dumps(wishes_dict)
        else:
            return render_template('error.html', error = 'Unauthorized Access')
    except Exception as e:
        return render_template('error.html', error = str(e))

if __name__ == "__main__":
    app.run(port=80, debug=True)
