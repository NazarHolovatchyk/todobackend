
	$ mysql.server start
	$ mysql -u root
    > CREATE DATABASE todobackend;
    > CREATE USER 'todo'@'localhost' IDENTIFIED BY 'password';
    > GRANT ALL PRIVILEGES ON *.* TO 'todo'@'localhost' IDENTIFIED BY 'password';
    
    $ DJANGO_SETTINGS_MODULE=todobackend.settings.test python manage.py migrate
    $ DJANGO_SETTINGS_MODULE=todobackend.settings.test python manage.py test
