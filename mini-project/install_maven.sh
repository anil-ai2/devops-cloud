sudo apt install maven -y 

echo "mvn requires JAVA_HOME. If not setup, you should set it up "
echo "current JAVA_HOME is $JAVA_HOME"
echo "some quick commands"
cat <<EOF
    mvn -version
EOF