#! /usr/bin/python2

"""
IMPORTANT

To run this example in the CSC 315 VM you first need to make
the following one-time configuration changes:

# install psycopg2 python package
sudo apt-get update
sudo apt-get install python-psycopg2

# set the postgreSQL password for user 'osc'
sudo -u postgres psql
    ALTER USER osc PASSWORD 'osc';
    \q

# install flask
sudo apt-get install python-pip
pip install flask
# logout, then login again to inherit new shell environment

"""

"""
CSC 315
Spring 2020
John DeGood

Usage:
export FLASK_APP=app.py 
flask run
# then browse to http://127.0.0.1:5000/

Purpose:
Demonstrate Flask/Python to PostgreSQL using the psycopg
adapter. Connects to the 7dbs database from "Seven Databases
in Seven Days" in the CSC 315 VM.

This example uses Python 2 because Python 2 is the default in
Ubuntu 18.04 LTS on the CSC 315 VM.

For psycopg documentation:
https://www.psycopg.org/

This example code is derived from:
https://www.postgresqltutorial.com/postgresql-python/
https://scoutapm.com/blog/python-flask-tutorial-getting-started-with-flask
https://www.geeksforgeeks.org/python-using-for-loop-in-flask/
"""

import psycopg2
from config import config
from flask import Flask, render_template, request
 
def connect(query):
	""" Connect to the PostgreSQL database server """
	conn = None
	rows = ""
	try:
        # read connection parameters
		params = config()
 		
        # connect to the PostgreSQL server
		print('Connecting to the %s database...' % (params['database']))
		conn = psycopg2.connect(**params)
		print('Connected.')
		
		# create a cursor
		cur = conn.cursor()

		# execute a query using fetchall()
		print(query)
		cur.execute(query)
		rows = cur.fetchall()
		print(query)
		# close the communication with the PostgreSQL
		cur.close()
	except (Exception, psycopg2.DatabaseError) as error:
		print(error)
	finally:
		if conn is not None:
			conn.close()
			print('Database connection closed.')
    # return the query result from fetchall()
	if (rows is "INSERT 0 1") or (rows is "DELETE 1"):
	    return "success"	
	elif not rows:
		return ""
	elif(rows is not ""):
		return rows
	else:
		return ""
 
# app.py

app = Flask(__name__)


# serve form web page
@app.route("/")
def form():
    return render_template('my-form.html')

# handle form data
@app.route('/insertfunc', methods=['POST'])
def insert():
	numquery = "SELECT MAX (articleid) FROM article;"
	artid = connect(numquery)
	artnum = ''.join(str(v) for v in artid)
	print(artnum)
	artnum = artnum.strip('(')
	artnum = artnum.strip(')')
	artnum = artnum.strip(',')
	artnum = artnum.strip('L')
	print(artnum)
	articleid = str(int(artnum) + 1)
	print(articleid)
	date = request.form.get("date", "")
	title = request.form.get("title", "")
	author = request.form.get("author", "")
	body = request.form.get("body", "")
	query1 = "SELECT * FROM article WHERE articleid = \'" + articleid + "\';"
	rows = connect(query1)
	if (rows is not ""):
		return render_template('present.html')
	query = "INSERT INTO article (ArticleID, Date, Title, Author, Text, totalviews) Values ( \'" + articleid + "\', \'" + date + "\', \'" + title + "\', \'" + author + "\', \'" + body + "\', 0); \nCOMMIT;" 
	print(query)
	rows = connect(query)
	if (rows is not ""):
		return render_template('failed.html')
	else:
		tag = request.form.get("tags", "")
		if(',' in tag):
			taglist = tag.split(',', 4)
			for x in taglist:
				tagquery = "SELECT tagID FROM tag WHERE name = \'" + x + "\';"
				tagidrow = connect(tagquery)
				print(x + "     " + tagquery)
				if (tagidrow is ""):
					return render_template('tagfail.html')
				else:
					tagidnum = ''.join(str(v) for v in tagidrow)
					tagidnum = tagidnum.strip('(')
					tagidnum = tagidnum.strip(')')
					tagidnum = tagidnum.strip(',')
					tagidnum = tagidnum.strip('L')
					query3 = "INSERT INTO articletags (ArticleID, TagID) VALUES (\'" + articleid + "\', \' " + tagidnum + "\'); \nCOMMIT;"
					rows = connect(query3)
				if (rows is not ""):
					return render_template('taginsertfail.html') 		
			return render_template('success.html')
		else:
			tagidrow = connect("SELECT tagid FROM tag WHERE name = \'" + tag + "\';")
			tagidnum = ''.join(str(v) for v in tagidrow)
			tagidnum = tagidnum.strip('(')
			tagidnum = tagidnum.strip(')')
			tagidnum = tagidnum.strip(',')
			tagidnum = tagidnum.strip('L')
			rows = connect("INSERT INTO articletags (ArticleID, TagID) VALUES (\'" + articleid + "\', \' " + tagidnum + "\'); \nCOMMIT;")
			if(rows is not ""):		
				return render_template('taginsertfail.html')
		return render_template('success.html')

@app.route('/deletefunc', methods=['POST'])
def delete():    
	articleid = request.form.get("articleid", "")
	query1 = "SELECT * FROM article WHERE articleid = \'" + articleid + "\';"
	rows = connect(query1)
	if (rows is "") or (rows is "DELETE 0"):
		return render_template('failed.html')
	else:
		query = "DELETE FROM article WHERE articleid = \'" + articleid + "\';\nCOMMIT;"
		rows = connect(query)
		if (rows is "") or (rows is "DELETE 0"):
	   		return render_template('success.html')


@app.route('/searchfunc', methods=['POST'])
def search():
	searchby = request.form.get("searchby", "")
	info = request.form.get("info", "")
	print(searchby)
	query = "SELECT Title, Date, Author, Text, name, article.totalviews FROM article, articletags, tag WHERE article.articleid = articletags.articleid AND tag.tagID = articletags.tagid AND " + searchby + " ILIKE \'" + info + "\' ORDER BY title;"
	rows = connect(query + "")
	if rows is "":
		return render_template('empty.html')
	else:
		return render_template('selectresult.html', rows=rows) 

#handle user insert form data
@app.route('/user-insert', methods=['POST'])
def addUser():
	useridrow = connect("SELECT MAX (userid) FROM users;")
	useridnum = ''.join(str(v) for v in useridrow)
	useridnum = useridnum.strip('(')
	useridnum = useridnum.strip(')')
	useridnum = useridnum.strip(',')
	useridnum = useridnum.strip('L')
	userid = str(int(useridnum) + 1)
	username = request.form.get("username", "")
	userpass = request.form.get("userpass", "")
	role = request.form.get("role", "")
	name = request.form.get("name", "")
	query = "INSERT INTO users (userid, username, userpass, permissionset, name) Values ( \'" + userid + "\', \'" + username + "\', \'" + userpass + "\', \'" + role + "\', \'" + name + "\');\nCOMMIT;"
	print(query)
	connect(query)
	return render_template('success.html')

#handle user delete form data
@app.route('/user-delete', methods=['POST'])
def deleteUser():    
	userid = request.form.get("userid", "")
	query1 = "SELECT * FROM users WHERE userid = \'" + userid + "\';"
	print(query1)
	rows = connect(query1)
	if (rows is "") or (rows is "DELETE 0"):
		return render_template('failed.html')
	else:
		query = "DELETE FROM users WHERE userid = \'" + userid + "\';\nCOMMIT;"
		rows = connect(query)
	   	return render_template('success.html')

#handle user search form data
@app.route('/user-search', methods=['POST'])
def searchUser():
	usersearchid = request.form.get("usersearchid", "")
	query = "SELECT userid, name, username, permissionset FROM users WHERE userid ILIKE \'" + usersearchid + "\';"
	print(query)
	rows = connect(query + "")
	if rows is "":
		return render_template('failed.html')
	else:
		return render_template('selectresult2.html', rows=rows)
	
@app.route('/tagINSERT', methods=['POST'])
def tagINSERT():
	tagname = request.form.get("name", "")
	description = request.form.get("descr", "")
	totalv = "0"
	tagidrow = connect("SELECT MAX (tagid) FROM tag;")
	tagidnum = ''.join(str(v) for v in tagidrow)
	tagidnum = tagidnum.strip('(')
	tagidnum = tagidnum.strip(')')
	tagidnum = tagidnum.strip(',')
	tagidnum = tagidnum.strip('L')
	tagid = str(int(tagidnum) + 1)
	query = "INSERT INTO tag (tagid, name, descr, totalviews) Values ( \'" + tagid + "\', \'" + tagname + "\', \'" + description + "\', 0); \nCOMMIT;"
	print(query)
	connect(query)
	return render_template('success.html')

@app.route('/tagDELETE', methods=['POST'])
def tagDELETE():
	tagid = request.form.get("tagid", "")
	query1 = "SELECT * FROM tag WHERE tagid = \'" + tagid + "\';"
	print(query1)
	rows = connect(query1)
	if (rows is "") or (rows is "DELETE 0"):
		return render_template('failed.html')
	else:
		query = "DELETE FROM tag WHERE tagid = \'" + tagid + "\';"
		rows = connect(query)
	   	return render_template('success.html')

@app.route('/tagSEARCH', methods=['POST'])
def tagSEARCH():
	name = request.form.get("name", "")
	start = name + "%"
	query = "SELECT Name, TotalViews, COUNT(tagid) FROM tag NATURAL JOIN articletags WHERE Name ILIKE \'" + name + "\' GROUP BY Name, TotalViews;"
	print(query)
	rows = connect(query + "")
	if rows is "":
		return render_template('notagarticle.html')
	else:
		return render_template('selectresult1.html', rows=rows)


