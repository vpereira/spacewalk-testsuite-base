When(/^I install updates$/) do 
   sshout = `echo | ssh -l root -o StrictHostKeyChecking=no $TESTHOST spacewalk-service stop 2>&1`
end

When(/^I stop SUSE Manager$/) do
   sshout = `echo | ssh -l root -o StrictHostKeyChecking=no $TESTHOST spacewalk-service stop 2>&1`
   if ! $?.success?
        raise "Execute command failed: #{$!}: #{output}"
    end
end

When(/^I start SUSE Manager$/) do
   sshout = `echo | ssh -l root -o StrictHostKeyChecking=no $TESTHOST spacewalk-service start 2>&1`
   if ! $?.success?
        raise "Execute command failed: #{$!}: #{output}"
    end
end

When(/^I add test repos$/) do
    sshout = `echo | ssh -l root -o StrictHostKeyChecking=no $TESTHOST zypper ar -f http://you.suse.de/download/x86_64/update/SUSE-MANAGER/1.7/ test_updates 2>&1`
    if ! $?.success?
        raise "Execute command failed: #{$!}: #{output}"
    end
end
