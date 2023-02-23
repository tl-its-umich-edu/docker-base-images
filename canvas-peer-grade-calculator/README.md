# canvas-peer-grade-calculator - - README

This project is a deployment wrapper for Longhorn Open Ed Tech's [canvas-peer-grade-calculator](https://github.com/longhornopen/canvas-peer-grade-calculator).

Docker uses an image from the project's container package, [canvaspeergrade](https://github.com/longhornopen/canvas-peer-grade-calculator/pkgs/container/canvaspeergrade).

1. Copy `.env.sample` to `.env`…
    ```shell
    cp .env.sample .env
    ```
2. Edit `.env` contents, using the comments therein as a guide.  Additional
   information can be found in Longhorn's [README.md](https://github.com/longhornopen/canvas-peer-grade-calculator/blob/6a2ece08b61a16a28f57d841a0399ca99081cbf4/README.md)
   for their project.
3. Run the container with Docker `compose`…
    ```shell
    docker compose up --build
    ```
