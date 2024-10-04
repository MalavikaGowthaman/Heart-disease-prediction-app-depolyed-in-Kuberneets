## ML Model Development and Google Kubernetes Deployment Procedure

> **Note**: Ensure your Flask ML project works locally and has a `requirements.txt` file with all supporting libraries before starting the deployment process.

### Step-by-Step Guide:

### **Google Cloud Setup**
1. **Create a Google Account**:
   - Sign in or create a Google Account.

2. **Go to Google Cloud Console**:
   - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).

3. **Activate Free Credits**:
   - If you are a new user, activate free credits for Google Cloud services.

4. **IAM Configuration**:
   - Click on the left-side menu (three stacked horizontal lines) and go to **IAM & Admin**.

5. **Managed Resources**:
   - Select **Managed Resources** from the IAM section.

6. **Create a New Project**:
   - Click **Create Project**, provide a **Project ID** in lowercase (e.g., `heartkuberneteesgcp`), and click **Create**.

### **Google Cloud SDK and Docker Setup**
7. **Download Google Cloud SDK**:
   - Download the [Google Cloud SDK](https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKinstaller.exe) for Windows.

8. **Install Google Cloud SDK**:
   - Run the `.exe` installer and follow the installation process.

9. **Download Docker Desktop**:
   - Download Docker Desktop for Windows [here](https://docs.docker.com/desktop/install/windows-install/).

10. **Install Docker**:
   - Install Docker Desktop by following the instructions provided.

11. **Verify Docker Installation**:
   - Open **Command Prompt** and run the following command:
     ```bash
     docker --version
     ```
   - If Docker is installed correctly, you will see the Docker version displayed.

### **Kubernetes Setup**
12. **Download Kubernetes CLI (kubectl)**:
    - Download Kubernetes CLI binaries from [Kubernetes Official Downloads](https://kubernetes.io/releases/download/#binaries).

13. **Install kubectl**:
    - Follow the installation instructions for your operating system. After installation, run this command to verify:
    ```bash
    kubectl version --client
    ```

### **Google Cloud Authentication & Configuration**
14. **Authenticate Google Cloud**:
    - Authenticate with Google Cloud by running:
    ```bash
    gcloud auth login
    ```

15. **Initialize Google Cloud**:
    - Initialize Google Cloud by configuring the project:
    ```bash
    gcloud init
    ```

16. **Set Project ID**:
    - Set the project ID for your GKE cluster:
    ```bash
    gcloud config set project heartkuberneteesgcp
    ```

### **Docker Build and Push**
17. **Enable Cloud Build**:
    - Enable the Cloud Build service for your project:
    ```bash
    gcloud services enable cloudbuild.googleapis.com
    ```

18. **Build Docker Image**:
    - Build your Docker image for the Flask ML project:
    ```bash
    docker build -t malavikagowthaman/heart_ml_app .
    ```

19. **Tag Docker Image**:
    - Tag the Docker image for Google Container Registry:
    ```bash
    docker tag malavikagowthaman/heart_ml_app gcr.io/heartkuberneteesgcp/heart_ml_app
    ```

20. **Push Docker Image to Google Container Registry**:
    - Push the tagged image to Google Container Registry:
    ```bash
    docker push gcr.io/heartkuberneteesgcp/heart_ml_app
    ```

21. **Configure Docker with GCloud**:
    - Set up Docker to authenticate with Google Cloud:
    ```bash
    gcloud auth configure-docker
    ```

### **Google Kubernetes Engine (GKE) Configuration**
22. **Enable Kubernetes Engine API**:
    - Enable Kubernetes API for the project:
    ```bash
    gcloud services enable container.googleapis.com
    ```

23. **Create a GKE Cluster**:
    - Create a Kubernetes cluster for your application:
    ```bash
    gcloud container clusters create heart-ml-app --zone us-central1-a --num-nodes=1
    ```

24. **Get GKE Cluster Credentials**:
    - Get the credentials to connect to your Kubernetes cluster:
    ```bash
    gcloud container clusters get-credentials heart-ml-app --zone us-central1-a
    ```

25. **Update GCloud Components**:
    - Make sure GCloud components are up to date:
    ```bash
    gcloud components update
    ```

26. **Install GKE Authentication Plugin**:
    - Install the Kubernetes GKE authentication plugin:
    ```bash
    gcloud components install gke-gcloud-auth-plugin
    ```

    > If you encounter any errors, run **Google Cloud SDK Shell** as administrator and try installing the plugin again:
    ```bash
    gcloud components install gke-gcloud-auth-plugin
    ```

### **Kubernetes Deployment Configuration**
27. **Create Deployment YAML File**:
    - Create a deployment configuration file `heart-ml-deployment.yaml` with the following content:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: heart-ml-app-deployment
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: heart-ml-app
      template:
        metadata:
          labels:
            app: heart-ml-app
        spec:
          containers:
          - name: heart-ml-app
            image: gcr.io/heartkuberneteesgcp/heart_ml_app
            ports:
            - containerPort: 8080  # Change to the port your app is listening on
    ```

28. **Apply Deployment Configuration**:
    - Apply the deployment configuration to the cluster:
    ```bash
    kubectl apply -f heart-ml-deployment.yaml
    ```

29. **Create Service YAML File**:
    - Create a service configuration file `heart-ml-service.yaml` with the following content:

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: heart-ml-app-service
    spec:
      selector:
        app: heart-ml-app
      ports:
        - protocol: TCP
          port: 80         # External Port that users will access
          targetPort: 8080 # The port your app is running on inside the container
      type: LoadBalancer
    ```

30. **Apply Service Configuration**:
    - Apply the service configuration to expose your application:
    ```bash
    kubectl apply -f heart-ml-service.yaml
    ```

31. **Check Service**:
    - To check the status and get the external IP, run:
    ```bash
    kubectl get svc
    ```

### **Manage Kubernetes Resources**
32. **Access Kubernetes Dashboard**:
    - Go to **Google Cloud Console** → **Kubernetes Engine** → **Services & Ingress** to manage and view deployed services.

33. **Delete GKE Cluster**:
    - When you're done, delete the cluster to avoid charges:
    ```bash
    gcloud container clusters delete heart-ml-app --zone us-central1-a --project heartkuberneteesgcp
    ```

### **Additional Kubernetes Management**
34. **Debug Pods**:
    - To describe a specific pod:
    ```bash
    kubectl describe pod <pod-name>
    ```

35. **View Pod Logs**:
    - To view the logs of a specific pod:
    ```bash
    kubectl logs <pod-name>
    ```
