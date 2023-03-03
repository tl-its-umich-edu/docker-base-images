# canvas-peer-grade-calculator - - README

This project is a deployment wrapper for Longhorn Open Ed Tech's [canvas-peer-grade-calculator](https://github.com/longhornopen/canvas-peer-grade-calculator).

Docker uses an image from the project's container package, [canvaspeergrade](https://github.com/longhornopen/canvas-peer-grade-calculator/pkgs/container/canvaspeergrade).

## Run app locally in Docker

1. ### Create `.env`
   Copy `.env.sample` to `.env`…
    ```shell
    cp .env.sample .env
    ```
2. ### Edit `.env`
   Edit the contents of`.env`, using the comments therein as a guide.
   Additional information can be found in Longhorn's
   [README.md](https://github.com/longhornopen/canvas-peer-grade-calculator/blob/6a2ece08b61a16a28f57d841a0399ca99081cbf4/README.md)
   for their project.
3. ### Start the app
   Use Docker's `compose` to start the app and db containers…
    ```shell
    docker compose up --build
    ```
4. ### _(Temporary)_ Apply DB migrations  
    The following DB migration needs to be applied manually until it can be
    added to the Docker process and be applied automatically.  
    ```shell
    docker compose exec app php artisan migrate -n --force
    ```
   > 💡 Alternatively, if the app is running in debug mode and it is accessed
   > before the migrations are applied, the app will show a page with
   > error messages about the missing database tables.  Clicking the green 
   > "RUN MIGRATIONS" button on that page will also apply the migrations.
5. ### Host the app
   By default, the app is available at `https://localhost:8000/`. 
   However, the OAuth authorization process requires direct requests between 
   Canvas and the peer grading app.  Therefore, it will probably be necessary 
   to make the locally running app accessible to Canvas on the web using a 
   tool like [Loophole](https://loophole.cloud/).  For example…  
    ```shell
    loophole http 8000 --hostname ${USER}-peergrade
    ```  
   Then access the app at: `https://YOUR_USERNAME-peergrade.loophole.site`.  
   **_NOTE_**: The hostname registered with Loophole **_must_** also be used  
   in…
   * `APP_URL` in `.env`.
   * "Redirect URIs" in the Canvas API key.
   > 💡 Typically, this hosting can be activated at any time, even before the
   > app is running.  It can also be allowed to continue running while the
   > app is stopped, making it easier for debugging or configuration changes.
6. ### Access the app
   Requesting the root URL of the local app server will start the 
   authorization process with Canvas.  Canvas will ask for the app to be 
   authorized to work with the user's account.  Once authorized, the app 
   will show a list of Canvas courses they can access.
