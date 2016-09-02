# Deploying fastText-docker on Kubernetes

fastText is not currently a parallel-izable process.  So any use in Kubernetes (that I can foresee), would be either as:
- [Job](job.yaml) for running one-off analyses
- [Deployment](deployment.yaml) for accessing inside a cluster

# Getting Started
If you are unfamiliar with Kubernetes, I'd recommend trying these examples out with: [minikube](https://github.com/kubernetes/minikube).

After you've `minikube start`'d your local cluster, you can create either the deployment or run the classification job.  Example commands and expected output are below.

# Job Example
The job will just run the classification-example in the Kubernetes cluster (& schedule it) and leave the resulting logs.  No model will be captured.

```
$ kubectl apply -f job.yaml
job "fasttext-class" created

$ kubectl get jobs
NAME             DESIRED   SUCCESSFUL   AGE
fasttext-class   1         0            4s
Deck:kubernetes xeb$ kubectl describe job fasttext-class
Name:           fasttext-class
Namespace:      default
Image(s):       xebxeb/fasttext-docker:latest
Selector:       controller-uid=fd643bb1-70de-11e6-8192-42a11ce5e7a2
Parallelism:    1
Completions:    1
Start Time:     Fri, 02 Sep 2016 00:29:31 -0700
Labels:         controller-uid=fd643bb1-70de-11e6-8192-42a11ce5e7a2
                job-name=fasttext-class
Pods Statuses:  1 Running / 0 Succeeded / 0 Failed
No volumes.
Events:
  FirstSeen     LastSeen        Count   From                    SubobjectPath   Type            Reason                  Message
  ---------     --------        -----   ----                    -------------   --------        ------                  -------
  14s           14s             1       {job-controller }                       Normal          SuccessfulCreate        Created pod: fasttext-class-wcn9q


$ kubectl logs fasttext-class-wcn9q

--2016-09-02 07:29:34--  https://googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k
Resolving googledrive.com (googledrive.com)... 216.58.194.97, 2607:f8b0:4000:809::2001
Connecting to googledrive.com (googledrive.com)|216.58.194.97|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://8c47f35de2544a202d525720f08188d254682381.googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k [following]
--2016-09-02 07:29:44--  https://8c47f35de2544a202d525720f08188d254682381.googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k
....
64750K .......... .......... .......... .......... .......... 12.7M
64800K .......... .......... .......... .......... .......... 16.1M
64850K .......... .......... .......... .......... .......... 16.4M
64900K .......... .......... .......... .......... .......... 15.6M
64950K .......... .......... .......... .......... .......... 15.7M
65000K .......... .......... .......... .......... .......... 14.5M
65050K .......... .......... .......... .......... .......... 12.9M
65100K .......... .......... .......... .......... .......... 12.3M
65150K .......... .......... .......... .......... .......... 16.9M
65200K .......... .......... .......... .......... .......... 16.3M
65250K .......... .......... .......... .......... .......... 16.3M
65300K .......... .......... .......... .......... .......... 15.3M
65350K .......... .......... .......... .......... .......... 12.4M
65400K .......... .......... .......... .......... .......... 15.1M
65450K .......... .......... .......... .......... .......... 11.5M
65500K .......... .......... .......... .......... .......... 16.5M
65550K .......... .......... .......... .......... .......... 16.8M
65600K .......... .......... .......... .......... .......... 16.3M
65650K .......... .......... .......... .......... .......... 15.6M
65700K .......... .......... .......... .......... .......... 16.3M
65750K .......... .......... .......... .......... .......... 11.7M
65800K .......... .......... .......... .......... .......... 15.4M
65850K .......... .......... .......... .......... .......... 11.9M
65900K .......... .......... .......... .......... .......... 17.6M
65950K .......... .......... .......... .......... .......... 15.0M
66000K .......... .......... .......... .......... .......... 16.5M
66050K .......... .......... .......... .......... .......... 15.4M
66100K .......... .......... .......... .......... .......... 16.4M
66150K .......... .......... .......... .......... .......... 11.7M
66200K .......... .......... .......... .......... .......... 15.7M
66250K .......... .......... .......... .......... .......... 11.5M
66300K .......... .......... .......... .......... .......... 17.7M
66350K .......... .......... .......... .......... .......... 15.5M
66400K .......... .......... .......... .......... .......... 15.0M
66450K .......... .......... .......... .......... .......... 17.8M
66500K .......... .......... .......... .......... .......... 10.9M
66550K .......... .......... .......... .......... .......... 16.7M
66600K .......... .......... .......... .......... .......... 17.6M
66650K .......... .......... .......... .......... .......... 11.0M
66700K .......... .......... .......... .........             24.4M=4.8s

2016-09-02 07:29:59 (13.5 MB/s) - 'data/dbpedia_csv.tar.gz' saved [68341698]

dbpedia_csv/
dbpedia_csv/classes.txt
dbpedia_csv/test.csv
dbpedia_csv/train.csv
dbpedia_csv/readme.txt
make: Nothing to be done for `opt'.
Read 32M words
Number of words:  803537
Number of labels: 14


$
```

# Deployment Example
The deployment example will just get a running dev container from the Kubernetes cluster.  It won't do anything (unlike the Job)
```
$ kubectl create -f deployment.yaml
deployment "fasttext" created

$ kubectl get deployments
NAME       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
fasttext   1         1         1            0           19s

$ kubectl describe deployment fasttext
Name:                   fasttext
Namespace:              default
CreationTimestamp:      Fri, 02 Sep 2016 00:23:36 -0700
Labels:                 app=fasttext
Selector:               app=fasttext
Replicas:               1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
OldReplicaSets:         <none>
NewReplicaSet:          fasttext-657236089 (1/1 replicas created)
Events:
  FirstSeen     LastSeen        Count   From                            SubobjectPath   Type            Reason                  Message
  ---------     --------        -----   ----                            -------------   --------        ------                  -------
  11s           11s             1       {deployment-controller }                        Normal          ScalingReplicaSet       Scaled up replica set fasttext-657236089 to 1



$ kubectl get pods
NAME                       READY     STATUS    RESTARTS   AGE
fasttext-657236089-at1e4   1/1       Running   0          1m

$ kubectl exec -it fasttext-657236089-at1e4 /bin/bash216.58.194.97, 2607:f8b0:4000:80d::2001
Connecting to googledrive.com (googledrive.com)|216.58.194.97|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
Location: https://8c47f35de2544a202d525720f08188d254682381.googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k [following]
--2016-09-02 07:25:04--  https://8c47f35de2544a202d525720f08188d254682381.googledrive.com/host/0Bz8a_Dbh9QhbQ2Vic1kxMmZZQ1k
Resolving 8c47f35de2544a202d525720f08188d254682381.googledrive.com (8c47f35de2544a202d525720f08188d254682381.googledrive.com)... 216.58.218.97, 2607:f8b0:4005:801::2001
Connecting to 8c47f35de2544a202d525720f08188d254682381.googledrive.com (8c47f35de2544a202d525720f08188d254682381.googledrive.com)|216.58.218.97|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [application/x-gzip]
Saving to: 'data/dbpedia_csv.tar.gz'

    [                        <=>            ] 68,341,698  14.1MB/s   in 4.8s   

2016-09-02 07:25:19 (13.6 MB/s) - 'data/dbpedia_csv.tar.gz' saved [68341698]

dbpedia_csv/
dbpedia_csv/classes.txt
dbpedia_csv/test.csv
dbpedia_csv/train.csv
dbpedia_csv/readme.txt
make: Nothing to be done for `opt'.
Read 32M words
Number of words:  803537
Number of labels: 14
Progress: 1.1%  words/sec/thread: 1250676  lr: 0.098876  loss: 1.953058  eta: 0h0m h-14m

$ kubectl delete deployment fasttext

```
