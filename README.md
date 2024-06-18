# NASA Picture of the day

### Description:
- A simple astronomy photography app to showcase deployment using a Jenkins pipeline

### Pipeline phases:
1. **Build:** The app gets containerized using a `Dockerfile`
2. **Test:** The container gets created an a simple test is applied
3. **Push:** The image is then pushed to the `AWS ECR`
4. **Backend Infrastructure:** An `S3` bucket gets created for the backend
5. **Main Infrastructure:** The main infrastructure gets created

### For local deployment:
- Initialize `ngrok` service: `ngrok http 8080`

### Once it's deployed:
- Update context in your WSL or other local environment:
    - `aws eks update-kubeconfig --region eu-west-2 --name nasa-potd-eks-cluster`
- Get service:
    - `kubectl get services` -> type in the browser the `EXTERNAL-IP` of the service

### Destroy infrastructure:
- As the terraform infrastructure's backend is stored remotely in the backend bucket, we can destroy our infrastructure remotely:
    - Navigate to your repository (where you cloned it), and step into the `terraform` folder
    - Update repository to reflect latest changes:
        - `git pull`
    - Use these commands:
        - `terraform init`
        - `terraform destroy`
    - Finally stop `ngrok` forwarding service
