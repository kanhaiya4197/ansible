#######################################################################
# SET REGION PROFILE FOR SPRING
#######################################################################
JAVA_OPTS="${JAVA_OPTS} -Dspring.profiles.active=integration"

#######################################################################
# APPDYNAMICS AGENT CONFIG
#######################################################################
JAVA_OPTS="${JAVA_OPTS} -javaagent:/var/lib/appdynamics/CurrentAgent/javaagent.jar"

#######################################################################
# SET JASYPT PROFILE
#######################################################################
JAVA_OPTS="${JAVA_OPTS} -Djasypt.encryptor.password=ebead908c52a477a91b3e27ae2161cb168eb5884 -Djasypt.encryptor.algorithm=PBEWithMD5AndTripleDES"

#######################################################################
# CLIENT ENVIRONMENT ENCRYPTION KEYS
#######################################################################
export WOMBAT="8f8157d5f2884fe0a75fec3df1371188"
