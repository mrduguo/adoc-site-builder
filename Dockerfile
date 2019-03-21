# To build image:
# docker build -t mrduguo/adoc-site-builder:latest -f Dockerfile .
# To preview:
# docker run -it --name adoc-site-builder --rm -v $(pwd):/workspace -p 4242:4242 mrduguo/adoc-site-builder bundle exec rake preview
# curl -v localhost:4242/kb/engineering/architecture/sample-diagram/
# To troubleshooting:
# docker run -it --name adoc-site-builder --rm -v $(pwd):/workspace mrduguo/adoc-site-builder bash
# To build site:
# docker run -it --name adoc-site-builder --rm -v $(pwd):/workspace mrduguo/adoc-site-builder


# docker run -it --name adoc-site-builder --rm -v $(pwd):/workspace  -v $(pwd)/../adoc-site-demo:/workspace/kb -p 4242:4242 mrduguo/adoc-site-builder bundle exec rake preview

FROM fedora:24

RUN echo "deltarpm=false" >> /etc/dnf/dnf.conf

RUN dnf -y update
RUN dnf -y install \
  git \
  libffi-devel \
  libxml2-devel \
  libxslt-devel \
  net-tools \
  graphviz \
  java-1.8.0-openjdk \
  patch redhat-rpm-config \
  ruby-devel \
  rubygem-bundler
RUN dnf -y groupinstall "C Development Tools and Libraries"
RUN dnf clean all

ENV LANG en_US.UTF-8

WORKDIR /workspace
ADD . /workspace
RUN ls -alth /workspace

RUN bundle config --local build.nokogiri --use-system-libraries
RUN bundle

CMD ["bundle", "exec" , "rake","build"]
