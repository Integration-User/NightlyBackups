<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_Created_from_Updated_Linkedin_Contact_Info_2</fullName>
        <description>Lead Created from Updated Linkedin Contact Info 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>jspencer@greenstreet.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Process_Notifications/New_Lead_Created_from_Updated_Contact_from_LinkedIn</template>
    </alerts>
    <outboundMessages>
        <fullName>AppcuesOnContactCreateUpdate_1UKMAA</fullName>
        <apiVersion>37.0</apiVersion>
        <endpointUrl>https://45e065f2-1011-4343-b48b-b9b6133547e7-a09589641cd9a93.integration-hook.com</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ksantos@greenstreet.com</integrationUser>
        <name>AppcuesOnContactCreateUpdate_1UKMAA</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>AppcuesOnContactCreateUpdate_1UKMAA</fullName>
        <actions>
            <name>AppcuesOnContactCreateUpdate_1UKMAA</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>!ISBLANK(Id)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
