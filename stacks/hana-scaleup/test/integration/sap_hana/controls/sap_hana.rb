project_id = attribute('project_id')
zone     = attribute('zone')
instance_name = attribute('instance_name')

control "instance" do
  describe google_compute_instance(project: "#{project_id}",  zone: "#{zone}", name: "#{instance_name}") do
    its('status') { should eq "RUNNING" }
  end
end