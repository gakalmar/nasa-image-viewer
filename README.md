# NASA Picture of the day

## Description:
- A simple astronomy photography app to showcase deployment using a Jenkins pipeline

### The Pipeline phases:
1. **Build:** 
    - The app gets containerized using a `Dockerfile`
2. **Test:**
    - The container gets created an a simple test is applied
3. **Push:**
    - The image is then pushed to the `AWS ECR`
4. **Backend Infrastructure:**
    - An `S3` bucket gets created for the backend
5. **Main Infrastructure:**
    - The main infrastructure gets created

### Once it's deployed:
- Update context in your WSL or other local environment:
    - `aws eks update-kubeconfig --region eu-west-2 --name nasa-potd-eks-cluster`
    - Test: `kubectl get nodes`
- Get service:
    - `kubectl get services` -> type in the browser the `EXTERNAL-IP` of the service