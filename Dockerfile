FROM docker.io/library/tomcat:9-jre17

ARG VERSION=1.4.0
ENV GUACAMOLE_HOME=/etc/guacamole

RUN mkdir -vp ${GUACAMOLE_HOME}/extensions && \
    curl -o ./webapps/guacamole.war -L https://apache.org/dyn/closer.lua/guacamole/${VERSION}/binary/guacamole-${VERSION}.war?action=download && \
    echo "92fb06e3ce8fe4f932ddfdffd75a352c06ab58d3bd0a946faa5beda73e8592f0 webapps/guacamole.war" | sha256sum --check && \
    curl -o /tmp/guacamole-auth-sso.tar.gz -L https://apache.org/dyn/closer.lua/guacamole/${VERSION}/binary/guacamole-auth-sso-${VERSION}.tar.gz?action=download && \
    echo "55ef6adac3beb753361b67eadda1c789ce3ffc70fe74794e9ddef70d8e6b8b8c  /tmp/guacamole-auth-sso.tar.gz" | sha256sum --check && \
    tar --wildcards -zxvf /tmp/guacamole-auth-sso.tar.gz guacamole-auth-sso-${VERSION}/openid/*.jar -O > /etc/guacamole/extensions/guacamole-auth-oidc.jar && \
    rm -f /tmp/guacamole-auth-sso.tar.gz

COPY guacamole.properties /etc/guacamole/guacamole.properties
COPY logback.xml /etc/guacamole/logback.xml
COPY user-mapping.xml /etc/guacamole/user-mapping.xml
