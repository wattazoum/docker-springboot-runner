[![license](https://img.shields.io/github/license/wattazoum/docker-springboot-runner.svg?style=flat-square)](https://opensource.org/licenses/MIT)

[![Docker Automated buil](https://img.shields.io/docker/automated/wattazoum/springboot-runner.svg?style=flat-square)](https://hub.docker.com/r/wattazoum/springboot-runner/)
[![Docker Pulls](https://img.shields.io/docker/pulls/wattazoum/springboot-runner.svg?style=flat-square)](https://hub.docker.com/r/wattazoum/springboot-runner/)
[![Docker Stars](https://img.shields.io/docker/stars/wattazoum/springboot-runner.svg?style=flat-square)](https://hub.docker.com/r/wattazoum/springboot-runner/)

# SPRINGBOOT Runner

> Based on [`openjdk:8u121-jre-alpine`](https://hub.docker.com/_/openjdk/) docker image. 

This image is more that just a [Spring Boot](https://projects.spring.io/spring-boot/) runner. 
I can launch any java command.

I created it first because I needed to launch a spring boot application in a container.
But I didn't want to:
* recreate an image for every version
* customize the `docker run` command per environment.

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


## Caracteristics

Specificities of this image consist in:

### a `springboot` user (uid=1000)
The container runs on a user called `springboot` 
with the `uid 1000`. This allows every file created by the application to be used
by user `uid=1000` on the docker host.

### a volume `/app`

The `WORKDIR` of the container. This folder might contain one and
only one jar/war, which is the springboot application jar.  
Creating a `/app/config/` directory will be automatically detected by Springboot 
as the configuration folder. See SpringBoot documentation on [externalizing configuration]. 
We also recommend the creation of the `logs` folder inside the `/app` folder.
The `/app` folder may also contain the `setenv.sh` file mentionned bellow.

[externalizing configuration]: http://docs.spring.io/spring-boot/docs/1.5.x/reference/html/boot-features-external-config.html

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
APP_ARGS="--loglevel=debug"
```

> **Note**: 
> The content of the file can be more complex than the sample above. It will be 
> interpreted by `/bin/sh` so all of the _DASH_ syntax is supported

## Changelog

### v1.1 

* JRE is **8r121**
* Integration of **fontconfig** and **ttf-dejavu** due to the [following JRE fontconfig bug](https://github.com/docker-library/openjdk/issues/73)

### v1.0

* JRE is **8r111**

