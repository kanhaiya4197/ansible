#######################################################################
# SET REGION PROFILE FOR SPRING
#######################################################################
JAVA_OPTS="$JAVA_OPTS -Dspring.profiles.active=development"

#######################################################################
# APPDYNAMICS AGENT CONFIG
#######################################################################
#JAVA_OPTS="${JAVA_OPTS} -javaagent:/var/lib/appdynamics/CurrentAgent/javaagent.jar"

#######################################################################
# SET JASYPT PROFILE
#######################################################################
JAVA_OPTS="${JAVA_OPTS} -Djasypt.encryptor.password=ebead908c52a477a91b3e27ae2161cb168eb5884 -Djasypt.encryptor.algorithm=PBEWithMD5AndTripleDES -Djasypt.encryptor.iv-generator-classname=org.jasypt.iv.NoIvGenerator"

#######################################################################
# SET LD Library
#######################################################################
export LD_LIBRARY_PATH=/var/lib/tomcat9/lib

