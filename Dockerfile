FROM ubuntu:latest
RUN apt-get update && \
	apt-get install -y \
		awscli \
		curl \
		bzip2 \
		blender 

ADD run-blender-job.sh /usr/local/bin/run-blender-job.sh
WORKDIR /tmp
USER nobody

ENTRYPOINT ["/usr/local/bin/run-blender-job.sh"]
