# SPRINGBOOT Runner

This image is more that just a [spring boot] runner.

I created it first because I needed to launch a spring boot application in a container.
But I didn't want to:
* recreate an image for every version
* customize the `docker run` command per environment.

## Caracteristics

Specificities of this image consist in:

### a `springboot` user (uid=1000)
The container runs on a user called `springboot` 
with the `uid 1000`. This allows every file created by the application to be used
by user `uid=1000` on the docker host.

### a volume `/app`

The `WORKDIR` of the container. This folder might contain one and
only one jar, which is the springboot application jar.  
Creating a `/app/config/` directory will be automatically detected by Springboot 
as the configuration folder.  
We also recommend the creation of the `logs` folder inside the `/app` folder.
The /app folder may also contain the `setenv.sh` file mentionned bellow.

### a port 8080

The defaut springboot http port is `8080`. This port is exposed by the container.
So no need to change it in your configuration.

### a (optional) `setenv.sh` file

This file allows you to set options to be passes to the `java` command.
The resulting command will be in the form of :
```
java $JAVA_OPTS -jar my_detected_jar $APP_ARGS
```

The following options are available (both optional):
* **JAVA_OPTS**: sets the java options to be passed. It can contain:
  * JVM behavior settings. eg. `-Xmx1g`
  * system properties. eg. `-Dfile.encoding=utf8`
* **APP_ARGS**: usually argument to be passed to the main class of the jar.

Here is an exemple of content: 
```
JAVA_OPTS="-Xmx1g -Dfile.encoding=utf8"
APP_ARGS=""--loglevel=debug
```

> **Note**: 
> The content of the file can be more complex than the sample above. It will be 
> interpreted by `/bin/sh` so all of the _DASH_ syntax is supported

## Usage

### Long story short

> `docker run -name <myapp> -v <myappfolder>:/app -p 8080:8080 springboot-runner`
> 
> Then access to http://localhost:8080 .


### Using the `java` command

This is not the purpose of this image, but if needed, you can use 
it to launch a `java` custom command.

```
$ docker run --rm -it springboot-runner -version

openjdk version "1.8.0_111-internal"
OpenJDK Runtime Environment (build 1.8.0_111-internal-alpine-r0-b14)
OpenJDK 64-Bit Server VM (build 25.111-b14, mixed mode)
```

Every command passed to the container will directly be fed to the `java` executable 
inside the container.

