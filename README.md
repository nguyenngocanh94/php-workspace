# Multi PHP projects with a single docker compose

## Stack: Nginx, PHP-FPM, MySQL, Postgres


## Quick start

it is all in one docker-compose for php development. Follow these step to start.

1. Run make script to start workspace
```bash
    sudo ./make.sh
 ```
2. Clone project into App folder. 
3. Run init script to create project web.
```bash
  # sudo ./init.sh laravel laravel/public
  sudo ./init.sh {sitename} {index.php directory} 
```
remember that name of folder is sitename.
4. manually access into `php8` container to run `composer install` and do some project setup commands (migrate, seed database ...).
5. enjoy by access http://sitename.test

### Note:
Since the docker has already been installed xdebug, and config. so what we need is install xdebug helper on chrome, and setup xdebug config in PHPSTORM.
Un-tick the auto-detect IDE address, then put `10.254.254.254` if your computer is macbook.