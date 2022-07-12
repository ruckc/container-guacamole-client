FROM docker.io/library/tomcat:9-jre17

ARG VERSION=1.4.0
ENV GUACAMOLE_HOME=/etc/guacamole

RUN mkdir -vp ${GUACAMOLE_HOME}/extensions && \
    # setup guacamole.war
    curl -o ./webapps/guacamole.war -L https://apache.org/dyn/closer.lua/guacamole/${VERSION}/binary/guacamole-${VERSION}.war?action=download && \
    echo "92fb06e3ce8fe4f932ddfdffd75a352c06ab58d3bd0a946faa5beda73e8592f0 webapps/guacamole.war" | sha256sum --check && \
    # setup oidc & jdbc authentication
    curl -o /tmp/guacamole-auth-sso.tar.gz -L https://apache.org/dyn/closer.lua/guacamole/${VERSION}/binary/guacamole-auth-sso-${VERSION}.tar.gz?action=download && \
    curl -o /tmp/guacamole-auth-jdbc.tar.gz -L https://apache.org/dyn/closer.lua/guacamole/${VERSION}/binary/guacamole-auth-jdbc-${VERSION}.tar.gz?action=download && \
    echo "55ef6adac3beb753361b67eadda1c789ce3ffc70fe74794e9ddef70d8e6b8b8c  /tmp/guacamole-auth-sso.tar.gz" | sha256sum --check && \
    echo "47f4f121cad74ab64d5baf3d14e8f709677a26b3058005a977277a07716d4d9c  /tmp/guacamole-auth-jdbc.tar.gz" | sha256sum --check && \
    tar --wildcards -zxvf /tmp/guacamole-auth-sso.tar.gz guacamole-auth-sso-${VERSION}/openid/*.jar -O > /etc/guacamole/extensions/guacamole-auth-oidc.jar && \
    tar --wildcards -zxvf /tmp/guacamole-auth-jdbc.tar.gz guacamole-auth-jdbc-${VERSION}/postgresql/*.jar -O > /etc/guacamole/extensions/guacamole-auth-jdbc.jar && \
    # cleanup
    rm -f /tmp/guacamole-auth-sso.tar.gz /tmp/guacamole-auth-jdbc.tar.gz

COPY guacamole.properties /etc/guacamole/guacamole.properties
COPY logback.xml /etc/guacamole/logback.xml
COPY user-mapping.xml /etc/guacamole/user-mapping.xml
