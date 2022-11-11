# UDOIT
The Universal Design Online content Inspection Tool, or UDOIT (pronounced, “You Do It”) enables faculty to identify accessibility issues in Canvas by Instructure. It will scan a course, generate a report, and provide resources on how to address common accessibility issues.

Changes in this branch for Michigan.

The docker-compose.yml currently in master is good for development and rebuilding changes, but for production it can _potentially_ be easier to manage and for costs to have just a single container with the whole stack. 

Typical issues with production: Want to limit the number of containers running form management and cost, may want to auto-run migrations, want to have everything statically compiled, and containers may not be allowed to run as root.

With the most recent version I've really [slimmed down the changes we had to make locally](https://github.com/tl-its-umich-edu/UDOIT/tree/umich-3.3.1) to run it but some of these could be useful.

1) Start script that checks to see if the database is available and runs any migrations 
2) Start script also fixes up the user id when running as non root
3) Starts supervisord which starts php-fpm and nginx as both in a single container
4) Slight changes to the Dockerfile for nginx adjustments to run as non-root and to install the composer dependencies.

We are deploying to an old version of Openshift which doesn't support the `COPY --from` syntax for composer but that would probably work out better than running the getcomposer.org/installer. 
