//
//  JsonReader.m
//  pod
//
//  Created by 郑江荣 on 16/3/9.
//  Copyright © 2016年 郑江荣. All rights reserved.
//

#import "JsonReader.h"

#import "farwolf.h"
#import "UIViewController+Farwolf.h"
@implementation JsonReader



-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.param=[[NSMutableDictionary alloc] init];
        self.header=[[NSMutableDictionary alloc] init];
        self.stream=[[NSMutableDictionary alloc] init];
        
    }
    return self;
}


-(void) addParam:(NSString *)key value:(NSString *)value
{
    [self.param setValue:value forKey:key];
    
}



-(void) addParam:(NSString *)key file:(NSObject *)value
{
    [self.stream setValue:value forKey:key];
    
}

-(void) addHeader:(NSString *)key value:(NSString *)value
{
    [self.header setValue:value forKey:key];
}

-(NSMutableArray*)toList:(NSString *)key
{
    
    return nil;
}

-(NSString*)getUrl
{
    return _url;
}



-(Json*)getDecoder
{
    return [Json alloc];
}


-(NSURLSessionDataTask*) excuteFile:( id<JsonProtocol>) j
{
    [j start];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString* url=[self getUrl];
    NSLog(@"url=%@",url);
    NSLog(@"param=%@",self.param);
    NSMutableDictionary *p=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *f=[[NSMutableDictionary alloc]init];
    NSArray *n= self.param.allKeys;
    
    for(NSString *key in n)
    {
        NSObject *o= p[key];
        if([o isKindOfClass:[NSString class]])
        {
            [p setObject:self.param[key] forKey:key];
        }
        else
        {
            [f setObject:self.param[key] forKey:key];
        }
    }
    
    NSURLSessionDataTask *task= [manager POST:url parameters:self.param headers:self.header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *nx= f.allKeys;
        for(NSString *key in nx)
        {
            NSObject *o= p[key];
            if([o isKindOfClass:[UIImage class]])
            {
                NSData *data = UIImagePNGRepresentation((UIImage*)o);
                [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/png"];
            }
            else if([o isKindOfClass:[NSData class]])
            {
                [formData appendPartWithFileData:o name:key fileName:key mimeType:@"application/octet-stream"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
    }];
    return task;
    
}

-(void)setSessionId:(NSString*)sessionId
{
    [self addHeader:@"Cookie" value:sessionId];
}
-(NSURLSessionDataTask*)excute:( id<JsonProtocol> )j
{
   return [self excute:j usePost:true];
}

-(NSURLSessionDataTask*)excute:( id<JsonProtocol>) j usePost:(BOOL)usePost
{
    
    
   return [self excuteFull:^{
        [j start];
    } success:^(Json *jx) {
        [j success:jx];
    } fail:^(Json *jx, NSInteger code, NSString *msg) {
        
        
        [j fail:code errmsg:msg json:jx];
    } exception:^{
        [j exception];
        [j compelete];
    } compelete:^{
        [j compelete];
    }usePost:usePost];
    
}
-(NSURLSessionDataTask*)excute:(UIViewController*)vc
      success:(void(^)(Json*j))success
{
  return  [self excute:vc success:success usePost:true];
}
-(NSURLSessionDataTask*)excute:(UIViewController*)vc
      success:(void(^)(Json*j))success usePost:(BOOL)usePost
{
    if(self.p==nil)
        self.p= [[LockScreenProgress alloc]initWith:vc.view];
    
    //    __weak typeof(LockScreenProgress) *weakp = self.p;
     __weak typeof (self)weakSlef=self;
  return  [self excuteFull:^{
        [weakSlef.p show];
    } success:^(Json *jx) {
        success(jx);
    } fail:^(Json *jx, NSInteger code, NSString *msg) {
        [vc toast:msg];
    } exception:^{
        [vc toast:@"网络异常！"];
        
    } compelete:^{
        [weakSlef.p hide];
    } usePost:usePost];
}

-(NSURLSessionDataTask*)excute:(UIViewController*)vc
                         success:(void(^)(Json*j))success fail:(void(^)(Json*j,NSInteger code,NSString*msg))fail usePost:(BOOL)usePost
{
    if(self.p==nil)
        self.p= [[LockScreenProgress alloc]initWith:vc.view];
     __weak typeof (self)weakSlef=self;
    //    __weak typeof(LockScreenProgress) *weakp = self.p;
    return  [self excuteFull:^{
        [weakSlef.p show];
    } success:^(Json *jx) {
        success(jx);
    } fail:^(Json *jx, NSInteger code, NSString *msg) {
        fail(jx,code,msg);
    } exception:^{
        [vc toast:@"网络异常！"];
        
    } compelete:^{
        [weakSlef.p hide];
    } usePost:usePost];
}

-(NSURLSessionDataTask*)excuteFull:(void(^)())start
          success:(void(^)(Json*j))success
             fail:(void(^)(Json*j,NSInteger code,NSString* msg))fail
        exception:(void(^)())exception
        compelete:(void(^)())compelete

{
   return [self excuteFull:start success:success fail:fail exception:exception compelete:compelete usePost:true];
}

-(NSURLSessionDataTask*)excuteFull:(void(^)())start
          success:(void(^)(Json*j))success
             fail:(void(^)(Json*j,NSInteger code,NSString* msg))fail
        exception:(void(^)())exception
        compelete:(void(^)())compelete
          usePost:(BOOL)usePost
{
    
    start();
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    
    NSString* url=[self getUrl];
    NSLog(@"url=%@",url);
    NSLog(@"param=%@",self.param);
    //(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    
    NSMutableDictionary *d=   self.header;
    for(NSString *key in d.allKeys)
    {
        NSString *v=d[key];
        [manager.requestSerializer setValue:v forHTTPHeaderField:key];
    }
    
    __weak typeof (self)weakSlef=self;
    if(usePost)
    {
       return [manager POST:url parameters:self.param headers:self.header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
             
        } progress:^(NSProgress * _Nonnull uploadProgress) {
             
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self success:task responseObject:responseObject start:start success:success fail:fail exception:exception compelete:compelete];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
        }];
    }
    else
    {
        
        NSArray *n=   [self.param allKeys];
        NSMutableDictionary *temp=[NSMutableDictionary new];
        for(NSString *key in n)
        {
            NSString *value=self.param[key];
//            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [temp setValue:value forKey:key];
        }
       return [manager POST:url parameters:self.param headers:self.header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self success:task responseObject:responseObject start:start success:success fail:fail exception:exception compelete:compelete];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败");
            NSLog(@"%@", error.userInfo[@"NSLocalizedDescription"]);
            exception();
            compelete();
        }];
    }
    
    
    
}

-(NSURLSessionDataTask*)excuteNoLimit:(UIViewController*)vc
             success:(void(^)(Json*j))success
             usePost:(BOOL)usePost
{
    if(self.p==nil)
        self.p= [[LockScreenProgress alloc]initWith:vc.view];
   return [self excuteNoLimit:^{
        [self.p show];
    } success:success exception:^{
        [vc toast:@"网络异常！"];
    } compelete:^{
        [self.p hide];
    } usePost:usePost];
}

-(NSURLSessionDataTask*)excuteNoLimit:(void(^)())start
             success:(void(^)(Json*j))success

           exception:(void(^)())exception
           compelete:(void(^)())compelete
             usePost:(BOOL)usePost
{
    
    start();
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    
    NSString* url=[self getUrl];
    NSLog(@"url=%@",url);
    NSLog(@"param=%@",self.param);
    //(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    
    NSMutableDictionary *d=   self.header;
    for(NSString *key in d.allKeys)
    {
        NSString *v=d[key];
        [manager.requestSerializer setValue:v forHTTPHeaderField:key];
    }
     __weak typeof (self)weakSlef=self;
    
    if(usePost)
    {
        return [manager POST:self.url parameters:self.param headers:self.header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields= [response allHeaderFields];
            
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(result);
            
            NSString* sessionId = [NSString stringWithFormat:@"%@",[[response.allHeaderFields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
            Json *res=[[self getDecoder] initWithString:result];
            res.resHeader=response.allHeaderFields;
            res.sessionId=sessionId;
            res.tag=self.tag;
            res.backString=result;
            success(res);
            compelete();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败");
            NSLog(@"%@", error.userInfo[@"NSLocalizedDescription"]);
            exception();
            compelete();
        }];
    }
    else
    {
        NSArray *n=   [self.param allKeys];
        NSMutableDictionary *temp=[NSMutableDictionary new];
        for(NSString *key in n)
        {
            NSObject *value=self.param[key];
            NSString *t=[@"" add:value];
            //            t = [t stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [temp setValue:t forKey:key];
        }
        return [manager GET:url parameters:self.param headers:self.header progress:^(NSProgress * _Nonnull downloadProgress) {
             
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields= [response allHeaderFields];
            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:url]];
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(result);
            NSString* sessionId = [NSString stringWithFormat:@"%@",[[response.allHeaderFields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
            Json *res=[[self getDecoder] initWithString:result];
            res.sessionId=sessionId;
            res.resHeader=response.allHeaderFields;
            res.tag=self.tag;
            res.backString=result;
            success(res);
            compelete();
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败");
            NSLog(@"%@", error.userInfo[@"NSLocalizedDescription"]);
            exception();
            compelete();
        }];  
 
    }
    
    
    
}




-(void)success:(NSURLSessionDataTask *)operation responseObject:(id)responseObject start: (void(^)())start
       success:(void(^)(Json*j))success
          fail:(void(^)(Json*j,NSInteger code,NSString* msg))fail
     exception:(void(^)())exception
     compelete:(void(^)())compelete
{
    @try {
        //            NSLog(responseObject);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(result);
        NSHTTPURLResponse* response = operation.response;
        
        NSString* sessionId =response.allHeaderFields[@"Set-Cookie"];
//         NSString* sessionId = [NSString stringWithFormat:@"%@",[[response.allHeaderFields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
//        NSLog([@"sessionid====" add: sessionId]);
        //            NSData* jsondata = [result dataUsingEncoding:NSUTF8StringEncoding];
        
        Json *res=[[self getDecoder] initWithString:result];
        res.sessionId=sessionId;
        res.tag=self.tag;
        res.resHeader=response.allHeaderFields;
        res.backString=result;
        if([res isSuccess])
        {
            success(res);
            //                [j success:res];
        }
        else
        {
            fail(res,[res getErrorCode],[res getErrorMsg]);
            
        }
        
    }
    @catch (NSException *exceptio) {
        exception();
        
    }
    @finally {
        compelete();
        
    }
    
}







@end
