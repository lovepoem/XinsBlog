#!/usr/bin/env node

const https = require('https');
const fs = require('fs');

const siteUrl = 'https://wangxin.io/';

console.log('🔍 开始性能检测...');

// 检测网站响应时间
function checkResponseTime() {
    return new Promise((resolve, reject) => {
        const startTime = Date.now();
        
        https.get(siteUrl, (res) => {
            const endTime = Date.now();
            const responseTime = endTime - startTime;
            
            console.log(`⏱️  响应时间: ${responseTime}ms`);
            console.log(`📊 状态码: ${res.statusCode}`);
            console.log(`📦 内容长度: ${res.headers['content-length'] || '未知'} bytes`);
            console.log(`🗜️  压缩: ${res.headers['content-encoding'] || '无'}`);
            console.log(`🏷️  缓存: ${res.headers['cache-control'] || '无'}`);
            
            resolve({
                responseTime,
                statusCode: res.statusCode,
                contentLength: res.headers['content-length'],
                compression: res.headers['content-encoding'],
                cache: res.headers['cache-control']
            });
        }).on('error', reject);
    });
}

// 检测静态资源
function checkStaticResources() {
    const resources = [
        '/scss/base/index.css',
        '/js/common.js',
        '/images/wangxin.png'
    ];
    
    console.log('\n📁 检测静态资源...');
    
    resources.forEach(resource => {
        const resourceUrl = siteUrl + resource.substring(1);
        const startTime = Date.now();
        
        https.get(resourceUrl, (res) => {
            const endTime = Date.now();
            const responseTime = endTime - startTime;
            
            console.log(`  ${resource}: ${responseTime}ms (${res.statusCode})`);
        }).on('error', (err) => {
            console.log(`  ${resource}: 错误 - ${err.message}`);
        });
    });
}

// 生成性能报告
async function generateReport() {
    try {
        const result = await checkResponseTime();
        checkStaticResources();
        
        const report = {
            timestamp: new Date().toISOString(),
            url: siteUrl,
            performance: result,
            recommendations: [
                result.responseTime > 1000 ? '⚠️  响应时间过长，建议优化服务器配置' : '✅ 响应时间良好',
                !result.compression ? '⚠️  未启用压缩，建议启用Gzip' : '✅ 已启用压缩',
                !result.cache ? '⚠️  未设置缓存策略' : '✅ 已设置缓存'
            ]
        };
        
        console.log('\n📋 性能报告:');
        report.recommendations.forEach(rec => console.log(`  ${rec}`));
        
        // 保存报告
        fs.writeFileSync('performance-report.json', JSON.stringify(report, null, 2));
        console.log('\n💾 报告已保存到 performance-report.json');
        
    } catch (error) {
        console.error('❌ 检测失败:', error.message);
    }
}

generateReport();
