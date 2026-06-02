FROM amazonlinux:2

# Install dependencies
RUN yum update -y && \
    yum install -y \
        wget \
        curl \
        tar \
        shadow-utils \
        fontconfig \
        dejavu-sans-fonts && \
    yum clean all

# Install Java 21 manually
RUN wget https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm && \
    yum localinstall -y amazon-corretto-21-x64-linux-jdk.rpm && \
    rm -f amazon-corretto-21-x64-linux-jdk.rpm

# Create Jenkins user
RUN useradd -m -d /var/lib/jenkins -s /bin/bash jenkins

# Set Jenkins home
ENV JENKINS_HOME=/var/lib/jenkins

# Create directories with correct permissions
RUN mkdir -p $JENKINS_HOME /usr/share/jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME /usr/share/jenkins

# Download Jenkins WAR
RUN wget -O /usr/share/jenkins/jenkins.war \
    https://get.jenkins.io/war-stable/latest/jenkins.war

# Java environment
ENV JAVA_HOME=/usr/lib/jvm/java-21-amazon-corretto
ENV PATH=$JAVA_HOME/bin:$PATH

# Expose port
EXPOSE 8080

# Switch user
USER jenkins

# Start Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war", "--httpPort=8080"]
