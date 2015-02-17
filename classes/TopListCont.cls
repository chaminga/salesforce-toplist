public with sharing class TopListCont {
    public Map<Id, User> UserMap {get; set;}
    public Map<Id, Integer> UserClassCountMap {get; set;} 
    public Map<Id, Integer> UserTriggerCountMap {get; set;} 
    public Map<Id, Integer> UserPageCountMap {get; set;} 
    public Map<Id, Integer> UserObjectCountMap {get; set;} 
    public String debug {get; set;}
    
    
    public TopListCont(){
        UserClassCountMap = new Map<Id, Integer>();
        UserTriggerCountMap= new Map<Id, Integer>();
        UserPageCountMap = new Map<Id, Integer>();
        UserObjectCountMap = new Map<Id, Integer>();
    
        UserMap = new Map<Id, User>([select Id, Name from User]);
        
        initMaps(UserMap);
        //-----
        AggregateResult[] classCounts = [SELECT COUNT(Id), CreatedById FROM ApexClass GROUP BY CreatedById];   
        
        for (AggregateResult cc : classCounts)  {
            UserClassCountMap.put(String.valueof(cc.get('CreatedById')), Integer.valueOf(cc.get('expr0')));
        }
        //-----
        AggregateResult[] triggerCounts = [SELECT COUNT(Id), CreatedById FROM ApexTrigger GROUP BY CreatedById];   
        
        for (AggregateResult cc : triggerCounts )  {
            UserTriggerCountMap.put(String.valueof(cc.get('CreatedById')), Integer.valueOf(cc.get('expr0')));
        }
        //-----
        AggregateResult[] pageCounts = [SELECT COUNT(Id), CreatedById FROM ApexPage GROUP BY CreatedById];   
        
        for (AggregateResult cc : pageCounts )  {
            UserPageCountMap.put(String.valueof(cc.get('CreatedById')), Integer.valueOf(cc.get('expr0')));
        }
        //----

        ToolingAPI toolingAPI = new ToolingAPI();

        List<ToolingAPI.CustomObject> customObjects = (List<ToolingAPI.CustomObject>)
                                                     toolingAPI.query('Select Id, DeveloperName, NamespacePrefix, CreatedById From CustomObject').records;                             
                                              
         
        for (ToolingAPI.CustomObject customObject: customObjects){
            Integer objectCount = userObjectCountMap.containsKey(customObject.CreatedById) ? userObjectCountMap.get(customObject.CreatedById)+1 : 0;
            userObjectCountMap.put(customObject.CreatedById, objectCount);
        }  
    }

    public void initMaps(Map<Id, User> userMap){
         for (Id userId: userMap.keySet()){
            UserClassCountMap.put(userId, 0);
            UserTriggerCountMap.put(userId, 0);
            UserPageCountMap.put(userId, 0);
            UserObjectCountMap.put(userId, 0);
        }
    }
}