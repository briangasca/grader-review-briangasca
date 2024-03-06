CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f student-submission/ListExamples.java ]
then
    echo "file found"
else
    echo "file not found"
    echo "0%"
    exit
fi

cp student-submission/ListExamples.java TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java

if [[ $? -eq 0 ]]
then
    echo "Compilation Successful."
else
    echo "Compilation Failed."
    echo "0%"
    exit
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples | tail -n 2 | head -n 1 > grade.txt

if grep -q 'OK' grade.txt
then
    echo "100%"
    exit
else
    grep -Eo '[0-9]+' grade.txt > result.txt

    tests=$(sed -n '1p' "result.txt")
    failures=$(sed -n '2p' "result.txt")

    tests_mult=$(($tests * 100))

    failures_mult=$(($failures * 100))

    difference=$(($tests_mult - $failures_mult))

    grade=$(($difference / $tests)) 
    echo $grade"%"
fi

